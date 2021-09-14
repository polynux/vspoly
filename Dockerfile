# Start from the code-server Debian base image
FROM codercom/code-server:3.11.1

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json .local/share/code-server/User/tasks.json

# Use bash shell
ENV SHELL=/bin/bash
RUN sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh
ADD ./.profile.d/heroku-exec.sh /app/.profile.d/heroku-exec.sh
RUN sudo chmod a+x /app/.profile.d/heroku-exec.sh

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Install fira-code
RUN sudo apt-get install fonts-firacode

# Install extensions
RUN code-server --install-extension akamud.vscode-theme-onedark
RUN code-server --install-extension vscode-icons-team.vscode-icons
RUN code-server --install-extension coenraads.bracket-pair-colorizer-2
RUN code-server --install-extension naumovs.color-highlight
RUN code-server --install-extension anseki.vscode-color
RUN code-server --install-extension dbaeumer.vscode-eslint
RUN code-server --install-extension donjayamanne.git-extension-pack
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension oderwat.indent-rainbow
RUN code-server --install-extension bierner.markdown-checkbox
RUN code-server --install-extension bierner.markdown-preview-github-styles
RUN code-server --install-extension eg2.vscode-npm-script
RUN code-server --install-extension christian-kohler.npm-intellisense
RUN code-server --install-extension esbenp.prettier-vscode


# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_14.x | sudo bash -
RUN sudo apt-get install -y nodejs

# Install localtunnel and nextjs
# RUN npm i -g localtunnel next

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
