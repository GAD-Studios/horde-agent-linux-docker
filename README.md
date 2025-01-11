# Horde Agent (Linux + Wine) Docker Setup

Setup for running [Horde Agents](https://dev.epicgames.com/documentation/en-us/unreal-engine/horde-agent-deployment-for-unreal-engine?application_version=5.5) on **Linux**, with **Wine** enabling Windows-based tasks (e.g. compilation using `cl.exe`, `link.exe`, or UnrealBuildAccelerator).

## Prerequisites

- **Docker** 
- A **Horde Server** URL accessible from this container.
- Optionally, a **download token** (`HORDE_AGENT_DOWNLOAD_TOKEN`) if your server requires authentication to fetch the agent zip.

## How to Build and Run

1. **Clone or copy** this repository to your local machine.
2. **Configure the Agent**

Copy the example `agent-config/Agent.example.json` to `agent-config/Agent.json`:

```sh
cp agent-config/Agent.example.json agent-config/Agent.json
```

Fill in `{{URL}}`, `{{AGENT_REGISTRATION_TOKEN}}`, `{{COMPUTE_IP}}` and `{{AGENT_NAME}}` fields.

> [!NOTE]
> Docker will self-report its container ip as the compute ip to the horde server, which will prevent other clients from connecting to it.
> Ensure you supply the ip of the host machine running the container.

> [!NOTE]
> Navigating to the http://[HORDE-SERVER-URL]/account page with an admin user logged in will include a Get agent registration token link.
> The first time an agent connects to the server, it will generate a unique connection token for itself.

3. **Build the Docker image**:

   ```bash
   docker build -t horde-agent .
   ```

4. **Run the container**, passing at least the `HORDE_SERVER_URL` environment variable:

   ```bash
   docker run -d \
     --name horde-agent \
     -p 7000-7010:7000-7010 \
     -e HORDE_SERVER_URL="http(s)://{{URL}}" \
     -e HORDE_AGENT_DOWNLOAD_TOKEN="OptionalDownloadTokenHere" \
     horde-agent
   ```

5. **Check the logs**:

   ```bash
   docker logs -f horde-agent
   ```

   You should see messages indicating the download and extraction of the Horde Agent, followed by a successful startup.

6. **Verify** your new agent in the **Horde Dashboard** (e.g., under Server > Agents) to ensure it’s connected and ready.




