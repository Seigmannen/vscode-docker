# Use an Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/temurin-21-jdk

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    gradle \
    git \
    unzip \
    openssh-client \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Eclipse Temurin JDK 21
RUN wget -qO- https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor > /usr/share/keyrings/adoptium.asc \
    && echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb focal main" > /etc/apt/sources.list.d/adoptium.list \
    && apt-get update && apt-get install -y temurin-21-jdk

# Install code-server (VS Code for the browser)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install VS Code extensions
RUN code-server --install-extension GitHub.vscode-pull-request-github \
    && code-server --install-extension eamodio.gitlens \
    && code-server --install-extension SpyglassMC.Datapack-Helper-Plus \
    && code-server --install-extension SPGoding.syntax-mcfunction \
    && code-server --install-extension redhat.java \
    && code-server --install-extension vscjava.vscode-java-debug \
    && code-server --install-extension alefragnani.project-manager \
    && code-server --install-extension christian-kohler.path-intellisense \
    && code-server --install-extension CoenraadS.bracket-pair-colorizer-2 \
    && code-server --install-extension mhutchie.git-graph \
    && code-server --install-extension richardwillis.vscode-gradle

# Set up default code-server configuration
RUN mkdir -p ~/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080" > ~/.config/code-server/config.yaml

# Expose the code-server port
EXPOSE 8080

# Add Gradle to PATH
ENV PATH="$PATH:/usr/share/gradle/bin"

# Set working directory
WORKDIR /workspace

# Start code-server by default
CMD ["code-server"]