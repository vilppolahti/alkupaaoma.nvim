#!/bin/bash

# alkupaaoma.nvim - Dependency Installation Script
# Installs all system-level dependencies for the Neovim configuration
# Supports: Arch Linux, Ubuntu/Debian

set -e

# Detect OS
if grep -qi "arch" /etc/os-release; then
  OS="arch"
elif grep -qi "ubuntu" /etc/os-release || grep -qi "debian" /etc/os-release; then
  OS="ubuntu"
else
  echo "❌ Unsupported OS. Only Arch Linux and Ubuntu/Debian are supported."
  exit 1
fi

# Function to print colored messages
print_info() {
  echo -e "\e[1;34m[INFO]\e[0m $1"
}

print_success() {
  echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}

print_error() {
  echo -e "\e[1;31m[ERROR]\e[0m $1"
}

# Function to install packages based on OS
install_packages() {
  print_info "Detected $OS. Installing dependencies..."
  
  case $OS in
    arch)
      print_info "Updating system and installing packages for Arch Linux..."
      sudo pacman -Syu --noconfirm --needed \
        git \
        neovim \
        base-devel \
        cmake \
        ninja \
        tree-sitter \
        nodejs \
        npm \
        python \
        python-pip \
        rustup \
        lldb \
        clang \
        gdb \
        unzip \
        curl \
        wget \
        ripgrep \
        fd \
        fzf \
        the_silver_searcher
      
      print_success "Arch Linux packages installed successfully."
      ;;
    ubuntu)
      print_info "Updating system and installing packages for Ubuntu/Debian..."
      sudo apt-get update -y
      sudo apt-get install -y \
        git \
        neovim \
        build-essential \
        cmake \
        ninja-build \
        nodejs \
        npm \
        python3 \
        python3-pip \
        python3-venv \
        rustc \
        cargo \
        lldb \
        clang \
        gdb \
        unzip \
        curl \
        wget \
        ripgrep \
        fd-find \
        fzf \
        silversearcher-ag
      
      print_success "Ubuntu/Debian packages installed successfully."
      ;;
  esac
}

# Install Rust toolchain (rustup, rustfmt, clippy)
install_rust() {
  if ! command -v rustup &> /dev/null; then
    print_info "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    rustup component add rustfmt clippy
    print_success "Rust toolchain installed successfully."
  else
    print_info "Rust toolchain already installed. Skipping."
  fi
}

# Install Node.js tools (prettier, eslint)
install_node_tools() {
  print_info "Installing Node.js tools..."
  npm install -g \
    prettier \
    eslint \
    eslint_d \
    @typescript-eslint/parser \
    @typescript-eslint/eslint-plugin
  print_success "Node.js tools installed successfully."
}

# Install Python tools (black, pylint)
install_python_tools() {
  print_info "Installing Python tools..."
  pip3 install --user \
    black \
    pylint \
    ruff \
    debugpy
  print_success "Python tools installed successfully."
}

# Install LLDB/CodeLLDB for debugging
install_debug_tools() {
  case $OS in
    arch)
      print_info "Installing CodeLLDB for Arch..."
      sudo pacman -S --noconfirm codelldb
      print_success "CodeLLDB installed successfully."
      ;;
    ubuntu)
      print_info "Installing CodeLLDB for Ubuntu/Debian..."
      local CODELLDB_VERSION=$(curl -s https://api.github.com/repos/vadimcn/codelldb/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
      wget -q "https://github.com/vadimcn/codelldb/releases/download/${CODELLDB_VERSION}/codelldb-x86_64-linux.vsix" -O /tmp/codelldb.vsix
      mkdir -p ~/.local/share/nvim/codelldb
      unzip -o /tmp/codelldb.vsix -d ~/.local/share/nvim/codelldb
      rm /tmp/codelldb.vsix
      print_success "CodeLLDB installed successfully."
      ;;
  esac
}

# Install Clang tools (clangd, clang-format, clang-tidy)
install_clang_tools() {
  case $OS in
    arch)
      print_info "Installing Clang tools for Arch..."
      sudo pacman -S --noconfirm clang clang-tools-extra
      print_success "Clang tools installed successfully."
      ;;
    ubuntu)
      print_info "Installing Clang tools for Ubuntu/Debian..."
      sudo apt-get install -y clang clangd clang-format clang-tidy
      print_success "Clang tools installed successfully."
      ;;
  esac
}

# Add cargo bin to PATH if not already present
add_cargo_to_path() {
  if ! grep -q "\.cargo/bin" "$HOME/.bashrc"; then
    print_info "Adding cargo bin to PATH..."
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
    print_success "Cargo bin added to PATH."
  fi
}

# Add npm global bin to PATH if not already present
add_npm_to_path() {
  if ! grep -q "npm global bin" "$HOME/.bashrc"; then
    print_info "Adding npm global bin to PATH..."
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
    print_success "npm global bin added to PATH."
  fi
}

# Main installation
print_info "Starting dependency installation for alkupaaoma.nvim..."

install_packages
install_rust
install_node_tools
install_python_tools
install_debug_tools
install_clang_tools
add_cargo_to_path
add_npm_to_path

print_success ""
print_success "✅ All dependencies installed successfully!"
print_info ""
print_info "Next steps:"
print_info "1. Restart your terminal or run: source ~/.bashrc"
print_info "2. Launch Neovim: nvim"
print_info "3. Inside Neovim, run: :Lazy sync"
print_info ""
print_info "Enjoy your new Neovim setup! 🎉"