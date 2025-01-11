#!/usr/bin/env bash
# ============================
# entrypoint.sh
# ============================
set -e

cd /home/horde/Horde

# 1) Validate environment variables
if [ -z "${HORDE_SERVER_URL}" ]; then
  echo "Error: HORDE_SERVER_URL must be set to download the Horde Agent."
  exit 1
fi

# 2) Download the latest Horde Agent to keep the container up-to-date
echo "Removing old Horde Agent files if any..."
rm -rf HordeAgent.zip bin obj *.dll *.pdb *.deps.json

DOWNLOAD_URL="${HORDE_SERVER_URL}/api/v1/agentsoftware/default/zip"

AUTH_HEADER=""
if [ -n "${HORDE_AGENT_DOWNLOAD_TOKEN}" ]; then
  echo "Using token-based authentication for Horde Agent download."
  AUTH_HEADER="-H \"Authorization: Bearer ${HORDE_AGENT_DOWNLOAD_TOKEN}\""
else
  echo "No token provided; attempting unauthenticated download (if server allows)."
fi

echo "Downloading Horde Agent from: $DOWNLOAD_URL"
eval curl -sSfL ${DOWNLOAD_URL} $AUTH_HEADER -o HordeAgent.zip

echo "Unzipping Horde Agent..."
unzip -o HordeAgent.zip -d .
rm HordeAgent.zip

# 3) Copy Agent.json to Data/Agent.json

echo "Copying Agent.json to appsettings.Production.json"
cp -f Agent.json appsettings.Production.json


# 4) Launch the Horde Agent
echo "Starting Horde Agent..."
exec dotnet HordeAgent.dll

