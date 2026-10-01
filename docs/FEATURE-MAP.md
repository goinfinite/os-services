# Feature Map

> Auto-maintained index of every user-facing feature and the code path that implements it. Updated alongside the code — not after the fact.

*Scope note:* this repo is a declarative catalog. The runtime that consumes it — Infinite OS (`goinfinite/os`) — is external; where a flow leaves this repo, the step names the external mechanism as documented in README.md rather than a file here.

## Installable service provisioning (databases, runtimes, webservers, misc)

A user creates a service in Infinite OS; the OS fetches this repo's manifest for the chosen branch/version, substitutes `%...%` placeholders, and runs the install steps on the host.

**Flow:**

1. `README.md` — defines the manifest schema, `nature`/`type` semantics, and the system placeholders (`%version%`, `%randomPassword%`, `%primaryHostname%`, `%installableServiceAssetsDirPath%`) that Infinite OS substitutes
2. `database|runtime|webserver|other/<service>/manifest.{yml,yaml,json}` — the per-service contract: `installCmdSteps` (apt repo setup, `apt-get update -qq`, `install_packages`, config templating), `startCmd`, `stopCmdSteps`, `uninstallCmdSteps`, `uninstallFilePaths`
3. `database|runtime|webserver|other/<service>/assets/*` — config templates and scripts copied into the host during install (e.g. `database/mongodb/assets/mongod.conf`)
4. *(external)* Infinite OS services manager — clones the repo branch and executes the steps; branch↔OS version mapping in `README.md` ("Cross-Version Support", citing `goinfinite/os src/infra/services/servicesCmdRepo.go`)

Config is surfaced back to the OS through the `/app/conf/<service>` symlink convention set up in install steps (see `database/*` manifests); logs go to `/app/logs/<service>`.

---

## PHP WebServer install channels (modern / legacy)

User installs php-webserver at any version from 5.6 to 8.5 (or `latest`/`legacy`); the version is mapped to an install channel that determines which lsphp package sets and configs land on the host.

**Flow:**

1. `runtime/php-webserver/manifest.yml` — entry: passes `%version%`, `%primaryHostname%`, `%installableServiceAssetsDirPath%` to the install script; then chowns `/app/conf/php-webserver` and `/app/logs/php-webserver` and registers the two OS cron jobs
2. `runtime/php-webserver/assets/install.sh` — `resolvePhpVersionChannel` maps the requested version to `latest` or `legacy`; `installModernPhpRuntimes` (OpenLiteSpeed + lsphp81–85 from repo.litespeed.sh) or `installLegacyPhpRuntimes` (Infinite apt repo with pinned GPG fingerprint + lsphp56/74/80); copies the matching httpd/vhost configs with hostname substitution
3. `runtime/php-webserver/assets/httpd_config.conf`, `primary.conf` (+ `legacy-*` variants) — server and vhost templates serving 8080/8443, PHP handler bound to lsphp82 (modern) / lsphp74 (legacy)
4. `runtime/php-webserver/assets/install_test.sh` — verifies the version→channel mapping (run manually; no CI hook)
5. Cron `AutoReloadPhpWebServerAfterHtaccessChange` (registered in step 1) — restarts the service when `.htaccess` files change under `/app/html`

---

## PHP modules dashboard

User toggles PHP extensions per version in the Infinite OS dashboard; the available list comes from this repo.

**Flow:**

1. `runtime/php-webserver/assets/modules.yaml` — maps each PHP version (5.6–8.5) to its toggleable modules (curl, mysqli, opcache, redis, ...)
2. *(external)* Infinite OS parses `assets/modules.yaml` and renders live module state — contract documented in `README.md` ("Assets"); the system installs only listed modules

---

## Hermes Agent install and version update

User installs hermes-agent from a release tag; later pins the running installation to a newer tag without reinstalling.

**Flow:**

1. `other/hermes-agent/manifest.yml` — install: uv + node@22 via mise, shallow `git clone --branch %version%` into `/app/hermes-agent`, editable `uv pip install`, config seeded from repo examples, `startCmd` runs the gateway on port 8644
2. `other/hermes-agent/update.sh` — update: validates the target tag exists on the remote (refuses `main`/`master`), clears stale git locks only when no git process runs, fetches + force-checks-out the tag, re-syncs submodules, reinstalls Python/npm deps into the existing venv, runs `hermes config check` and prints `hermes config migrate` if a migration is pending
3. *(external)* operator restarts the service (`os services update --name hermes-agent --status restart`, printed by the script) to load new code

---

## Supabase log pipeline (supabase-vector)

User installs supabase-vector; it tails Infinite OS / Kong service logs, parses and routes them per Supabase component, and ships them to a Logflare analytics endpoint.

**Flow:**

1. `other/supabase-vector/manifest.yaml` — install: vector 0.28.1-1 from setup.vector.dev, copies the pipeline config to `/etc/vector/vector.yaml`; `startCmd` runs `vector --config ...` (API on 0.0.0.0:9001)
2. `other/supabase-vector/assets/vector.txt` — file source tails `/app/logs/*/*.log` and Kong logs; remap transforms tag appname/stream; router branches per service (kong, auth, rest, realtime, storage, functions, db); per-service remaps parse nginx/json/regex formats
3. Logflare `http` sinks (end of `vector.txt`) — POST JSON to `http://analytics:4000/api/logs?source_name=...`; the db sink routes through Kong (`http://kong:8000/...`) per the startup-order comment

---

## Services CI (nightly install smoke test)

Maintainers get a nightly GitHub Actions report: every catalog service/version is installed inside a real Infinite OS container and classified PASS / FAIL / SKIP.

**Flow:**

1. `.github/workflows/ci-services.yml` (job `discover`) — embedded Python walks `database/`, `runtime/`, `webserver/`, `other/`, parses each `manifest.{json,yml,yaml}`, validates name/versions/portBindings/installCmdSteps, dedupes names, and emits the test matrix (`MATRIX`/`ALL_ITEMS` outputs; skip reasons recorded)
2. `.github/workflows/ci-services.yml` (job `test`) — per matrix entry: resolves the newest `goinfinite/os` Docker tag, starts a container (2 CPU / 4 GB), waits for `os version` readiness, runs `os services create-installable -n <name> -v <version> -p <port>` under a 1500s outer timeout, bundles CLI output + container log tail into a per-item result artifact, and cleans up the container
3. `.github/workflows/ci-services.yml` (job `report`) — merges artifacts with the discovery list, renders the Markdown summary table, and fails the run when any item failed
4. The services themselves (`*/manifest.*`) are the fixtures under test; a matrix entry exists only because a manifest declares the version

---

## Catalog version branching (repository releases)

Consumers pin the catalog to their Infinite OS version by cloning a branch instead of a release tag.

**Flow:**

1. `README.md` ("Cross-Version Support") — the mapping table: branch `v0` → OS v0.0.1–v0.1.5, `v1` → v0.1.7–v0.3.2, `v2` → v0.3.3+; all carry `manifestVersion: v1`
2. *(external)* Infinite OS clones the selected branch at install time (`git fetch`-based; referenced to `goinfinite/os src/infra/services/servicesCmdRepo.go` from README)

---

## System services (Cron, Nginx, OS API)

Core services Infinite OS manages internally; users cannot create, update, or remove them.

**Flow:**

1. `system/cron/assets/`, `system/nginx/assets/`, `system/os-api/assets/` — icons only; no manifests exist in this repo (see `system/.context.md`)
2. *(external)* `goinfinite/os src/infra/internalDatabase/model/installedService.go:50-93` — `InitialEntries()` seeds the three services with `type: system`, their start commands, and an `avatarUrl` that points back at the matching `system/<name>/assets/avatar.jpg` file in this repo
3. *(external)* `goinfinite/os src/domain/valueObject/serviceType.go` — the `system` service type; `src/domain/useCase/createCustomService.go:100`, `updateService.go:30` and `deleteService.go:99` refuse user create, update and delete on it

---
