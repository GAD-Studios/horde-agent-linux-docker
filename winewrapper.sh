#!/bin/bash
# ============================
# winewrapper.sh
# ============================
# Wrapper script for Wine providing a hook point to modify command-line
# arguments before calling wine64. This is especially useful for UnrealBuildAccelerator
# or other Windows-based tools used via Horde on Linux.

set -e

# Silence Wine debug output
export WINEDEBUG=-all
# Use 64-bit Wine
export WINEARCH=win64
# This is where Wine will store its virtual Windows filesystem
export WINEPREFIX=/opt/horde/wine-data

# Override or set a directory for UBA or other Windows-based paths
export UE_HORDE_SHARED_DIR="C:\\Uba"

# If we have a termination signal file, convert it to a Windows path (Z:\)
if [ -n "${UE_HORDE_TERMINATION_SIGNAL_FILE}" ]; then
  # Convert /some/path to Z:\some\path
  # Replace forward slashes with backslashes
  export UE_HORDE_TERMINATION_SIGNAL_FILE="Z:${UE_HORDE_TERMINATION_SIGNAL_FILE//\//\\}"
fi

# Finally, call the wine64 binary with the original arguments
exec /usr/bin/wine64 "$@"

