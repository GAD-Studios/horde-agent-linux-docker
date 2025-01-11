# ============================
# Dockerfile
# ============================
FROM ubuntu:22.04

# Ensure a non-interactive environment to avoid prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies and enable multiarch
RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        zip \
        unzip \
        software-properties-common \
        gnupg2 \
        nano \
        vim \
        jq \
    && rm -rf /var/lib/apt/lists/*

# 2. Add WineHQ repository and install Wine
RUN mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt-get update \
    && apt-get install -y --install-recommends \
        winehq-stable \
    && rm -rf /var/lib/apt/lists/*

# 3. Install .NET 8.0 runtime
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        dotnet-runtime-8.0 \
    && rm -rf /var/lib/apt/lists/*

# 4. Create a non-root 'horde' user
RUN useradd -m horde && \
    mkdir -p /home/horde/Horde && \
    chown -R horde:horde /home/horde

# 5. Copy wrapper script and entrypoint
COPY winewrapper.sh /usr/local/bin/winewrapper.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/winewrapper.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

# 6. Copy in a base Agent.json
COPY agent-config/Agent.json /home/horde/Horde/Agent.json

# 7. Set environment variables so the agent can locate Wine
ENV HORDE_WINE_WRAPPER_PATH=/usr/local/bin/winewrapper.sh

# 8. Switch to 'horde' user for security
USER horde

# 9. Set the working directory
WORKDIR /home/horde/Horde

# 10. Use the entrypoint script by default
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

