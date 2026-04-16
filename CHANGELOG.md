# CHANGELOG

## v1

```
# 2026/04/16

feat: add port binding 8644/http for hermes-agent (PR #65)

# 2026/04/14

feat: add hermes-agent

# 2026/03/23

feat: add Ruby runtime manifest (Issue #19)
  - runtime/ruby/manifest.yaml with tested versions: 1.8, 2.5, 2.6, 2.7, 3.0, 3.1, 3.2, 3.3, 3.4, 4.0
  - runtime/ruby/assets/avatar.png
  - Uses mise for version management
  - WEBrick-based default server on port 3000
  - Includes libffi-dev and libyaml-dev for compilation
  - Installs webrick gem (not included in Ruby 3.0+)
  - Uses 'mise x ruby@%version% -- ruby' in startCmd (standard pattern)
```

```
# 2025/12/05

chore: update node versions
```

```
# 2025/07/30

feat: add python runtime
```

```
# 2025/06/18

feat: add Bun
docs: add CHANGELOG.md
```

```
# 2024/10 to 2024/12

feat: add OpenSSH other manifest
feat: add Redis database manifest
feat: add PostgreSQL database manifest
feat: add PHP WebServer runtime manifest
feat: add OpenSearch database manifest
feat: add Node runtime manifest
feat: add MariaDB database manifest
feat: add Java runtime manifest
```

## v0

```
# 2024/10 to 2024/12

feat: add OpenSSH other manifest
feat: add Redis database manifest
feat: add PostgreSQL database manifest
feat: add PHP WebServer runtime manifest
feat: add OpenSearch database manifest
feat: add Node runtime manifest
feat: add MariaDB database manifest
feat: add Java runtime manifest
```
