#!/usr/bin/env bash
# @description  Install the php-webserver runtime for a selected version.
# @usage        install.sh <version> <primary-hostname> <assets-dir-path>
# @output       No standard output.
# @requires     bash v4+, apt-get, awk, curl, gpg, sed, tr
# @version      0.1.0
# @updated      2026-08-24

set -euo pipefail

installLiteSpeedRepository() {
  curl --silent --location https://repo.litespeed.sh | bash
}

installInfiniteAptRepositoryKey() {
  configuredFingerprint="<configured-full-fingerprint>"
  expectedFingerprint="$(printf '%s' "$configuredFingerprint" \
    | tr '[:lower:]' '[:upper:]')"
  case "$expectedFingerprint" in
    ''|*[![:xdigit:]]*) exit 1 ;;
  esac
  test "${#expectedFingerprint}" -eq 40
  keyFile="$(mktemp)"
  curl --fail --silent --show-error --location \
    https://cdn.goinfinite.net/apt/infinite-apt.gpg \
    --output "$keyFile"
  actualFingerprint="$(
    gpg --show-keys --with-colons "$keyFile" \
      | awk -F: '$1 == "fpr" {print toupper($10); exit}'
  )"
  test -n "$actualFingerprint"
  test "$actualFingerprint" = "$expectedFingerprint"
  install -Dm0644 "$keyFile" /usr/share/keyrings/infinite-apt.gpg
  rm -f "$keyFile"
}

installInfiniteAptSource() {
  cat > /etc/apt/sources.list.d/infinite-apt.list <<'EOF'
deb [signed-by=/usr/share/keyrings/infinite-apt.gpg] https://cdn.goinfinite.net/apt trixie main
EOF
}

installPhpPackageSet() {
  phpMajorVersion="${1:?PhpMajorVersionRequired}"
  apt-get install -y \
    "lsphp${phpMajorVersion}" "lsphp${phpMajorVersion}-common" \
    "lsphp${phpMajorVersion}-curl" "lsphp${phpMajorVersion}-intl" \
    "lsphp${phpMajorVersion}-mysql" "lsphp${phpMajorVersion}-opcache"
}

installServiceConfigAssets() {
  httpdConfigAssetName="${1:?HttpdConfigAssetNameRequired}"
  primaryConfigAssetName="${2:?PrimaryConfigAssetNameRequired}"
  primaryHostname="${3:?PrimaryHostnameRequired}"
  assetsDirPath="${4:?AssetsDirPathRequired}"

  cp -u "$assetsDirPath/$httpdConfigAssetName" \
    /usr/local/lsws/conf/httpd_config.conf
  sed -i "s/goinfinite.local/$primaryHostname/g" \
    /usr/local/lsws/conf/httpd_config.conf
  cp -u "$assetsDirPath/$primaryConfigAssetName" \
    /app/conf/php-webserver/template
  cp /app/conf/php-webserver/template /app/conf/php-webserver/primary.conf
  sed -i "s/goinfinite.local/$primaryHostname/g" \
    /app/conf/php-webserver/primary.conf
}

installModernPhpRuntimes() {
  primaryHostname="${1:?PrimaryHostnameRequired}"
  assetsDirPath="${2:?AssetsDirPathRequired}"

  installLiteSpeedRepository
  apt-get install -y openlitespeed
  for phpMajorVersion in 81 82 83 84; do
    installPhpPackageSet "$phpMajorVersion"
  done
  apt-get install -y lsphp85 lsphp85-common lsphp85-curl lsphp85-intl \
    lsphp85-mysql
  ln -sf /usr/local/lsws/lsphp82/bin/php /usr/bin/php
  installServiceConfigAssets httpd_config.conf primary.conf \
    "$primaryHostname" "$assetsDirPath"
}

installLegacyPhpRuntimes() {
  primaryHostname="${1:?PrimaryHostnameRequired}"
  assetsDirPath="${2:?AssetsDirPathRequired}"

  installLiteSpeedRepository
  apt-get install -y openlitespeed
  installInfiniteAptRepositoryKey
  installInfiniteAptSource
  apt-get update
  apt-get install -y lsphp-legacy-openssl lsphp-legacy-libcurl
  installPhpPackageSet 56
  installPhpPackageSet 74
  installPhpPackageSet 80
  ln -sf /usr/local/lsws/lsphp74/bin/php /usr/bin/php
  installServiceConfigAssets legacy-httpd_config.conf legacy-primary.conf \
    "$primaryHostname" "$assetsDirPath"
}

#
## Runtime
#

export DEBIAN_FRONTEND=noninteractive
selectedVersion="${1:?VersionRequired}"
primaryHostname="${2:?PrimaryHostnameRequired}"
assetsDirPath="${3:?AssetsDirPathRequired}"

case "$selectedVersion" in
  latest) installModernPhpRuntimes "$primaryHostname" "$assetsDirPath" ;;
  legacy) installLegacyPhpRuntimes "$primaryHostname" "$assetsDirPath" ;;
  *)
    echo "UnknownPhpWebServerVersion: $selectedVersion" >&2
    exit 1
    ;;
esac
