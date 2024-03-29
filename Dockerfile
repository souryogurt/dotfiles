# Use Fedora as the base image
FROM fedora:latest

# Update the system
RUN dnf -y update

# Install tools required for neovim plugins
RUN dnf -y install gcc make

# Install development tools
RUN dnf -y install bat direnv eza git neovim ripgrep stow tmux zoxide

# Create a user for the development environment and configure sudo access
RUN useradd -m dev && \
    echo "dev:dev" | chpasswd && \
    usermod --shell /bin/bash dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user
USER dev

# Set the working directory
WORKDIR /home/dev

# Copy local repository into the image
COPY --chown=dev:dev . ./src/github.com/souryogurt/dotfiles

RUN rm .bashrc .bash_profile && \
    cd ./src/github.com/souryogurt/dotfiles && \
    stow -Sv -t ~/ bat core direnv eza git nvim task tmux zoxide && \
    bat cache --build

# Set up an entry point to start a shell
ENTRYPOINT ["/bin/bash"]

