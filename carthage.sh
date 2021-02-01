#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Use 'setup', 'build', 'safebuild', 'fastbuild' or 'clean'"
    exit 1
fi

# This shell script is based on a workaround script called carthage.sh
# designed to fix incompatibilities between carthage and Xcode 12 (and in particular the lipo step)
# This is NOT the recommended solution, which would be usage of xcframework.

set -euo pipefail

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

# For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
# the build will fail on lipo due to duplicate architectures.
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_iphonesimulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(PLATFORM_NAME)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig
# echo 'ONLY_ACTIVE_ARCH=NO' >> $xcconfig
export XCODE_XCCONFIG_FILE="$xcconfig"
echo "XCODE_XCCONFIG_FILE:  $XCODE_XCCONFIG_FILE"
# carthage "$@"
if  [ $1 == "setup" ]; then 
 echo "Updating requirements and pulling dependencies, then attempting build"
 echo "carthage update  --new-resolver --platform iOS --no-use-binaries --no-cache-builds"
 carthage update  --new-resolver --platform iOS --no-use-binaries --no-cache-builds
 exit 0
elif [ $1 == "build" ]; then
  echo "Building project using Carthage.resolved"
  echo "carthage bootstrap  --new-resolver --platform iOS --no-use-binaries --no-cache-builds"
  carthage bootstrap  --new-resolver --platform iOS --no-use-binaries --no-cache-builds
  exit 0
elif [ $1 == "safebuild" ]; then
  echo "Building project using Carthage.resolved"
  echo "carthage bootstrap --platform iOS --no-use-binaries --cache-builds"
  carthage bootstrap --platform iOS --no-use-binaries --cache-builds
  exit 0
elif [ $1 == "fastbuild" ]; then
  echo "Building project using Carthage.resolved"
  echo "carthage bootstrap  --new-resolver --platform iOS --use-binaries --cache-builds"
  carthage bootstrap  --new-resolver --platform iOS --use-binaries --cache-builds
  exit 0
elif [ $1 == "clean" ]; then
  echo "Cleaning"
  rm Cartfile.resolved && rm -rf ~/Library/Caches/org.carthage.CarthageKit && rm -rf ~/Library/Caches/carthage
else
  echo "No such argument: $1"
  exit 1
fi
