# Infinite OS Services

This repository stores the installation and uninstallation manifests for all services supported by [Infinite OS](https://github.com/goinfinite/os).

## Cross-Version Support
This repository is versioned to ensure compatibility with both specific versions of Infinite OS and the `manifestVersion` property found in each manifest. The `manifestVersion` reflects the version of the individual manifest file.

Versioning for this repository is managed through branches, which act as releases. This allows users to clone only the desired branch corresponding to the required version, without the need for actual release tags:

```bash
git clone --single-branch --branch v0 https://github.com/goinfinite/os-services
```

> [!IMPORTANT]
> The versioning of this repository works differently from the Infinite OS versioning. It is important to understand that the versioning here is done through branches and not releases, and its structure also differs from the Infinite OS. The Infinite OS uses major, minor, and patch versions, whereas this repository uses only a single version level, as all changes have significant impacts on the entire services management.

Below is a mapping of repository versions and the respective Infinite OS versions and `manifestVersion` they support:

| Repository branch (version) | Infinite OS version | `manifestVersion` |
| -- | -- | -- |
| `v0` | [`v0.0.1`](https://github.com/goinfinite/os/releases/tag/v0.0.1) [`v0.0.2`](https://github.com/goinfinite/os/releases/tag/v0.0.2) [`v0.0.4`](https://github.com/goinfinite/os/releases/tag/v0.0.4) [`v0.0.6`](https://github.com/goinfinite/os/releases/tag/v0.0.6) [`v0.0.7`](https://github.com/goinfinite/os/releases/tag/v0.0.7)<br/> [`v0.0.9`](https://github.com/goinfinite/os/releases/tag/v0.0.9) [`v0.1.0`](https://github.com/goinfinite/os/releases/tag/v0.1.0) [`v0.1.2`](https://github.com/goinfinite/os/releases/tag/v0.1.2) [`v0.1.5`](https://github.com/goinfinite/os/releases/tag/v0.1.5) | `v1` |

## Manifest/Schema Properties
These manifests have their own property structure, which is read by Infinite OS during the management of these services. The supported formats are JSON (`.json`) and YAML (`.yml`, `.yaml`).

[PHP WebServer example](https://github.com/goinfinite/os-services/blob/v0/runtime/php-webserver/manifest.yml).

| Property | Type | Is required? | Description |
| -- | -- | -- | -- |
| `manifestVersion` | string | no | _The version of the manifest. This version changes whenever the manifest is updated, indicating the presence of new placeholders or new commands._ |
| `name` | string | yes | _The name of the service that the manifest represents._ |
| `slugs` | []string | no | _Reference names for the service, which can include full names, acronyms, or any identifier related to the service._ |
| `nature` | string | yes | _The nature of the service. It can be solo or multi._<br/><br/>`solo`: _services that are installed and used across Infinite OS with the same version and configuration, such as MariaDB._<br/>`multi`: _services installed as needed by the user, allowing different configurations and versions for each installation, such as Node.js._|
| `type` | string | yes | _The type of the service, which indicates its purpose._<br/><br/>`application`: _application services with their own functionality, such as Mattermost._<br/>`runtime`: _services that run code and applications, such as Java._<br/>`database`: _self-explanatory, such as PostgreSQL._<br/>`webserver`: _services that host and provide access to content and applications, such as Tomcat._<br/>`mom`: _messaging and queuing services, such as RabbitMQ._<br/>`monitoring`: _self-explanatory, such as Prometheus._<br/>`logging`: _self-explanatory, such as Grafana._<br/>`security`: _self-explanatory, such as Nmap._<br/>`backup`: _self-explanatory, such as Bacula._<br/>`system`: _services related to Infinite OS itself that cannot be created, updated, or removed, such as the Infinite OS API._ |
| `description` | string | yes | _A description of the service that explains what it is, what it does, and its purpose._ |
| `versions` | []string | no | _The versions available for installing the service._ |
| `portBindings` | []string | no | _Ports and protocols that will be bound by Infinite OS, enabling access to the service through these ports._ |
| `startCmd` | string | yes | _The command responsible for starting the service after its installation._ |
| `installCmdSteps` | []string | yes | _Commands to install the service. This is one of the main parts of the manifest, as it contains all the steps required to install dependencies, the service itself, and configure it. This can include editing necessary files, changing file permissions, or using Infinite OS CLI commands when needed._ |
| `uninstallCmdSteps` | []string | no | _Commands to uninstall the service. These steps typically reverse the installation commands, focusing on removing files and extra configurations that will no longer function without the service._ |
| `uninstallFilePaths` | []string | no | _File paths that will be deleted during the uninstallation of the service, as they are no longer needed._ |
| `stopCmdSteps` | []string | no | _Commands to stop the service. These steps usually include not only halting the service but also shutting down related dependencies, such as cronjobs._ |
| `estimatedSizeBytes` | string | no | _The estimated size of the service in bytes, providing clarity about the storage impact of the service._ |
| `avatarUrl` | string | no | _The URL for the service’s image, used for illustration purposes._ |

## System Placeholders
System placeholders are predefined values used by the Infinite OS to replace placeholders in installation commands. These placeholders are denoted by `%` at the beginning and end, such as `%adminName%`.

The repository will automatically substitute these placeholders with the appropriate values during the installation process. For example:

```bash
sed -i "s/goinfinite.local/%primaryHostname%/g" /usr/local/lsws/conf/httpd_config.conf
```

In this example, `%primaryHostname%` will be replaced with the primary hostname configured in Infinite OS.

Below is a table of all available system placeholders for creating manifests:

| Name | Type |Description |
| -- | -- | -- |
| `randomPassword` | string | _Automatically generated password by the system, eliminating the need for manual input._ |
| `version` | string | _The version selected for installation based on the versions available in the manifest._ |
| `primaryHostname` | string | _The primary hostname configured in Infinite OS._ |
| `installableServiceAssetsDirPath` | string | _Assets directory for the service to be installed. Useful for pre-prepared configuration files ready to be used directly during installation._ |
