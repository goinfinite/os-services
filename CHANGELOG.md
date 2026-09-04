# Changelog

## Services v2

```log
2.1.0 - 2026/09/04
feat(php): map concrete php versions to install channel
feat(php): register supported modules per legacy version
docs: explain the service assets directory

2.0.3 - 2026/08/27
ci: capture container logs, add install timeout, and apply code rules
fix(php): pin approved APT repository key fingerprint

2.0.2 - 2026/08/25
fix(ci): test every service version

2.0.1 - 2026/08/24
chore: raise php-webserver estimated size to 1 GiB

2.0.0 - 2026/08/04
feat(php): add legacy webserver profile
fix(php): align webserver with installed versions
feat: add v2 manifest branch
```

## Services v1

```log
1.32.0 - 2026/07/24
feat: add CI workflow for daily service testing
fix: handle duplicate names, missing artifacts, and add CI timeout

1.31.0 - 2026/07/22
feat: add daily LSWS swap cleanup cronjob

1.30.0 - 2026/07/21
fix: add PHP session garbage collection params to primary.conf (Issue #73)

1.29.0 - 2026/07/03
fix: handle both mariadb.list and mariadb.sources for MaxScale removal (Issue #71)

1.28.0 - 2026/06/02
feat: add MariaDB 11.8 LTS and 12.3 LTS

1.27.1 - 2026/05/05
fix: remove maxscale repository from mariadb setup

1.27.0 - 2026/04/16
feat: add port binding 8644/http for hermes-agent

1.26.0 - 2026/04/14
feat: add hermes-agent (Issue #62)
fix: hermes-agent avatar url (Issue #64)

1.25.0 - 2026/03/24
feat: add ruby (Issue #19)
docs: add context files

1.24.1 - 2026/03/17
chore: update ols config to add php84 and php85 support

1.24.0 - 2026/03/02
feat(runtime): add PHP 8.4 and 8.5 to php-webserver manifest
fix(runtime): handle missing lsphp85-opcache package

1.23.0 - 2026/02/02
feat: add mongodb
feat: add custom mongodb configuration file
fix: simplify MongoDB uninstall process

1.22.0 - 2026/01/30
feat: add vector customized for supabase

1.21.0 - 2026/01/26
feat: add vector observability data pipeline service

1.20.0 - 2026/01/20
feat: add kong webserver service
fix: correct kong avatar url path from runtime to webserver
fix: add keyring to uninstallFilePaths
refactor: consolidate kong_user schema privileges into single grant statement

1.19.0 - 2025/12/05
chore: update node manifest versions

1.18.0 - 2025/07/30
feat: add python runtime

1.17.0 - 2025/06/18
feat: add bun runtime
docs: add CHANGELOG
feat: add '.gitignore'

1.16.0 - 2025/05/09
docs: add `CONTRIBUTING.md`
docs: add `LICENSE.md`

1.15.1 - 2025/05/08
fix: images path now uses github pages

1.15.0 - 2025/03/13
chore: open mariadb connection to the world

1.14.1 - 2025/02/18
fix: unpin `openssh-server` version

1.14.0 - 2025/01/16
feat: add Cron system service avatar
feat: add NGINX system service avatar
feat: add OS API system service avatar
refactor: change Cron service avatar

1.13.0 - 2024/12/27
fix: add missing quote to opensearch pass
fix: quote my.cnf pass
fix: add simple quotes back to MariaDB manifest
chore: add important section explain about system placeholder auto-generated values to the end of README

1.12.1 - 2024/12/26
refactor: indent json manifests
refactor: change all v0 occurrences to v1
fix: remove simple quotes from MariaDB installation to avoid sql syntax error
chore: change repository origin on README reference
chore: change versioning explanation on README

1.12.0 - 2024/12/24
chore add explanation about versioning and v1 (version) to README

1.11.0 - 2024/12/20
refactor: using new system data field to access PHP WebServer assets on manifest

1.10.1 - 2024/12/19
fix: rename postgres dirs from v0 back to main
fix: using v0 instead main as the main branch

1.10.0 - 2024/12/17
refactor: add type to system placeholders table and modify some topics titles
fix: change cross-version support table headers
fix: change "marketplace catalog" mention to "services"
chore: add important alert on cross-version support README topic

1.9.0 - 2024/12/15
chore: add README

1.8.1 - 2024/12/06
fix: adjust assets path

1.8.0 - 2024/12/05
feat: add avatar to MariaDB assets
feat: add avatar to OpenSearch assets
feat: add avatar to PostgreSQL assets
feat: add avatar to Redis assets
feat: add avatar to Java assets
feat: add avatar to Node assets
feat: add avatar and webserver configs to PHP WebServer assets

1.7.1 - 2024/11/25
refactor: using install_packages instead apt update && apt install

1.7.0 - 2024/11/22
feat: add OpenSSH other manifest
feat: add OpenSSH other assets
fix: indent openssh manifest

1.6.0 - 2024/10/29
feat: add MariaDB database manifest
feat: add Java runtime manifest
feat: add Node runtime manifest
feat: add OpenSearch database manifest
feat: add PHP WebServer runtime manifest
feat: add PostgreSQL database manifest
feat: add Redis database manifest
```

## Services v0

```log
0.5.1 - 2024/12/26
fix: remove simple quotes from MariaDB installation to avoid sql syntax error
chore: change repository origin on README reference
chore: change versioning explanation on README

0.5.0 - 2024/12/24
chore add explanation about versioning to README

0.4.1 - 2024/12/19
fix: rename postgres dirs from v0 back to main
fix: using v0 instead main as the main branch

0.4.0 - 2024/12/17
refactor: add type to system placeholders table and modify some topics titles
fix: change cross-version support table headers
fix: change "marketplace catalog" mention to "services"
chore: add important alert on cross-version support README topic

0.3.0 - 2024/12/15
chore: add README

0.2.1 - 2024/12/06
fix: adjust assets path

0.2.0 - 2024/12/05
feat: add avatar to MariaDB assets
feat: add avatar to OpenSearch assets
feat: add avatar to PostgreSQL assets
feat: add avatar to Redis assets
feat: add avatar to Java assets
feat: add avatar to Node assets
feat: add avatar and webserver configs to PHP WebServer assets

0.1.1 - 2024/11/25
refactor: using install_packages instead apt update && apt install

0.1.0 - 2024/10/29
feat: add MariaDB database manifest
feat: add Java runtime manifest
feat: add Node runtime manifest
feat: add OpenSearch database manifest
feat: add PHP WebServer runtime manifest
feat: add PostgreSQL database manifest
feat: add Redis database manifest
```
