# Horde Agent (Linux + Wine) Docker Setup

Setup for running [Horde Agents](https://docs.unrealengine.com/ue5/en-US/horde-overview/) on **Linux**, with **Wine** enabling Windows-based tasks (e.g. compilation using `cl.exe`, `link.exe`, or UnrealBuildAccelerator).

Registration
Navigating to the http://[HORDE-SERVER-URL]/account page with an admin user logged in will include a Get agent registration token link. This token can be embedded into the default agent config file or passed to the SetServer command (see above).

The first time an agent connects to the server, it will generate a unique connection

## Prerequisites

- **Docker** 
- A **Horde Server** URL accessible from this container.
- Optionally, a **download token** (`HORDE_AGENT_DOWNLOAD_TOKEN`) if your server requires authentication to fetch the agent zip.

## How to Build and Run

1. **Clone or copy** this repository to your local machine.
2. **Build the Docker image**:

   ```bash
   docker build -t horde-agent .
   ```

3. **Run the container**, passing at least the `HORDE_SERVER_URL` environment variable:

   ```bash
   docker run -d \
     --name horde-agent \
     -e HORDE_SERVER_URL="https://{{URL}}" \
     -e HORDE_AGENT_DOWNLOAD_TOKEN="OptionalDownloadTokenHere" \
     horde-agent
   ```

4. **Check the logs**:

   ```bash
   docker logs -f horde-agent
   ```

   You should see messages indicating the download and extraction of the Horde Agent, followed by a successful startup.

5. **Verify** your new agent in the **Horde Dashboard** (e.g., under Server > Agents) to ensure it’s connected and ready.

## Configuration & Customization

### Mounting Volumes

- **Work Directory**  
  If you want to preserve intermediate data, Perforce workspaces, or logs across container restarts, consider mounting a volume:

  ```bash
  docker run -d \
    --name horde-agent \
    -v /my/local/horde-workdir:/home/horde/Horde/Work \
    -e HORDE_SERVER_URL="https://{{URL}}" \
    horde-agent
  ```

- **Wine Prefix**  
  The Wine filesystem is stored in `/opt/horde/wine-data`. If you wish to persist or inspect it:

  ```bash
  docker run -d \
    --name horde-agent \
    -v /my/local/horde-wine:/opt/horde/wine-data \
    -e HORDE_SERVER_URL="https://{{URL}}" \
    horde-agent
  ```

### Agent.json

Copy `agent-config/Agent.example.json` to `agent-config/Agent.json`

You may edit `agent-config/Agent.json` to:

- Add multiple server profiles.
- Insert a **registration token** for auto-registering this agent with your Horde server.
- Configure **Perforce** settings or **Shares**.
- Modify the **working directory** (`horde.workingDir`) or other advanced agent properties.

>[!NOTE] The `entrypoint.sh` script uses `jq` to update certain fields (e.g., `wineExecutablePath`). You can extend or modify it to patch other properties from environment variables.

### GPU Access

TODO
