# Use Fedora as the base image
FROM fedora:latest

# Update the system
RUN dnf -y update

# Install development tools
RUN dnf -y install bat direnv exa git neovim ripgrep stow tmux zoxide

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
COPY . ./dotfiles

RUN rm .bashrc .bash_profile && \
    cd dotfiles && \
    stow -Sv bat core direnv exa git nvim task tmux zoxide && \
    bat cache --build

# Set up an entry point to start a shell
ENTRYPOINT ["/bin/bash"]

