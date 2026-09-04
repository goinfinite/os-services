#!/usr/bin/env bash
# @description  Test resolvePhpVersionChannel version-to-channel mapping.
# @usage        install_test.sh
# @output       AssertChannel-prefixed result lines, plus a final
#               TestPass or TestFail summary.
# @requires     bash v4+
# @version      0.1.0
# @updated      2026-09-04

set -euo pipefail

# Note: Setup is intentionally inline — test independence requires each
# file to own its preconditions, even if it duplicates code.
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
# Directive path is dynamic, so shellcheck cannot follow it.
source "$scriptDir/install.sh"

testCount=0
failCount=0

expectChannel() {
  requestedVersion="$1"
  expectedChannel="$2"
  testCount=$((testCount + 1))
  resolvedChannel=""
  if ! resolvedChannel="$(
    resolvePhpVersionChannel "$requestedVersion" 2>/dev/null
  )"; then
    resolvedChannel="rejected"
  fi
  if test "$resolvedChannel" = "$expectedChannel"; then
  printf 'AssertChannelPass %s -> %s\n' "$requestedVersion" "$resolvedChannel"
  return
fi
printf 'AssertChannelMismatch %s expected %s got %s\n' \
  "$requestedVersion" "$expectedChannel" "$resolvedChannel"
  failCount=$((failCount + 1))
}

expectChannel latest latest
expectChannel legacy legacy

expectChannel 8.1 latest
expectChannel 82 latest
expectChannel 8.2 latest
expectChannel 83 latest
expectChannel 8.4 latest
expectChannel 8.5 latest

expectChannel 56 legacy
expectChannel 5.6 legacy
expectChannel 74 legacy
expectChannel 7.4 legacy
expectChannel 80 legacy
expectChannel 8.0 legacy

expectChannel 9 rejected
expectChannel 10.0 rejected
expectChannel 8.6 rejected
expectChannel 8.10 rejected
expectChannel 99 rejected
expectChannel 0.1 rejected
expectChannel 8.2.10 rejected
expectChannel foo rejected
expectChannel 8.x rejected
expectChannel "" rejected
expectChannel 08.02 rejected

if test "$failCount" -eq 0; then
  printf 'TestPass all %d version checks\n' "$testCount"
  exit 0
fi
printf 'TestFail %d of %d version checks\n' "$failCount" "$testCount"
exit 1
