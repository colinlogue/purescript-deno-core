FROM denoland/deno:alpine-1.43.6

# Install Node.js, npm, git, bash, and curl
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    bash \
    curl \
    && npm install -g typescript

# Create a non-root user that matches the default vscode user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user and group
RUN addgroup -g $USER_GID $USERNAME \
    && adduser -u $USER_UID -G $USERNAME -s /bin/bash -D $USERNAME

# Set up the working directory
WORKDIR /workspaces/purescript-deno-core

# Set ownership for the working directory
RUN mkdir -p /workspaces/purescript-deno-core \
    && chown -R $USERNAME:$USERNAME /workspaces/purescript-deno-core

# Switch to the vscode user by default
USER $USERNAME

# Update PATH to include Deno and npm
ENV PATH=/deno-dir/bin:$PATH
ENV PATH=/home/$USERNAME/.npm-global/bin:$PATH

# Setup npm global packages to be installed in user's home
RUN mkdir -p /home/$USERNAME/.npm-global \
    && npm config set prefix '/home/$USERNAME/.npm-global'
