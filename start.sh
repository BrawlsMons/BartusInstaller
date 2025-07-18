#!/bin/bash

# Bartus Server Installer Script for Debian Trixie
# This script sets up a complete server environment

# Clear screen and show banner
clear

echo "========================================================================"
echo "______            _               _____          _        _ _           "
echo "| ___ \          | |             |_   _|        | |      | | |          "
echo "| |_/ / __ _ _ __| |_ _   _ ___    | | _ __  ___| |_ __ _| | | ___ _ __ "
echo "| ___ \/ _\` | '__| __| | | / __|   | || '_ \/ __| __/ _\` | | |/ _ \ '_"
echo "| |_/ / (_| | |  | |_| |_| \__ \  _| || | | \__ \ || (_| | | |  __/ |   "
echo "\____/ \__,_|_|   \__|\__,_|___/  \___/_| |_|___/\__\__,_|_|_|\___|_|   "
echo "                                                                        "
echo "                                                                        "
echo "========================================================================"
echo "               Debian Trixie Server Setup Script                        "
echo "========================================================================"
echo ""

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_warning "This script is running as root. Some operations may behave differently."
fi

# Update system
print_step "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
print_step "Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    neovim \
    htop \
    tree \
    unzip \
    zip \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    tmux \
    screen \
    nano \
    less \
    grep \
    sed \
    awk \
    find \
    locate \
    net-tools \
    openssh-server \
    ufw \
    fail2ban

# Install zsh and oh-my-zsh
print_step "Installing ZSH and Oh My Zsh..."
sudo apt install -y zsh

# Install Oh My Zsh for current user
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install useful zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    # Update .zshrc with plugins
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker docker-compose)/' ~/.zshrc
else
    print_status "Oh My Zsh already installed"
fi

# Install Node.js and npm
print_step "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Python and pip
print_step "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv python3-dev

# Install Docker
print_step "Installing Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose (standalone)
print_step "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Configure Neovim
print_step "Configuring Neovim..."
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.vim << 'EOF'
" Basic Neovim configuration
set number
set relativenumber
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set mouse=a
set clipboard=unnamedplus
set ignorecase
set smartcase
set hlsearch
set incsearch
set wrap
set linebreak
set scrolloff=8
set sidescrolloff=8

" Color scheme
colorscheme desert

" Key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" File explorer
nnoremap <leader>e :Explore<CR>
EOF

# Configure SSH (if not already configured)
print_step "Configuring SSH..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Configure UFW firewall
print_step "Configuring UFW firewall..."
sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443

# Configure fail2ban
print_step "Configuring fail2ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Install additional useful tools
print_step "Installing additional tools..."
sudo apt install -y \
    jq \
    httpie \
    sqlite3 \
    postgresql-client \
    mysql-client \
    redis-tools \
    certbot \
    nginx \
    apache2-utils \
    rsync \
    rclone \
    ncdu \
    fd-find \
    ripgrep \
    bat \
    exa

# Install Rust and Cargo (for modern CLI tools)
print_step "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

# Create useful aliases
print_step "Setting up aliases..."
cat >> ~/.bashrc << 'EOF'

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vi='nvim'
alias vim='nvim'
alias python='python3'
alias pip='pip3'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'
EOF

# Add aliases to zsh too
cat >> ~/.zshrc << 'EOF'

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vi='nvim'
alias vim='nvim'
alias python='python3'
alias pip='pip3'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'
EOF

# Create a useful server info script
print_step "Creating system info script..."
sudo tee /usr/local/bin/sysinfo << 'EOF'
#!/bin/bash
echo "========================================================================"
echo "                           SYSTEM INFORMATION                          "
echo "========================================================================"
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
echo "Users: $(who | wc -l)"
echo "Processes: $(ps aux | wc -l)"
echo "========================================================================"
echo "                           NETWORK INFORMATION                         "
echo "========================================================================"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1
echo "========================================================================"
echo "                           DOCKER STATUS                               "
echo "========================================================================"
if command -v docker &> /dev/null; then
    echo "Docker version: $(docker --version)"
    echo "Running containers: $(docker ps -q | wc -l)"
else
    echo "Docker not installed"
fi
echo "========================================================================"
EOF

sudo chmod +x /usr/local/bin/sysinfo

# Set up automatic updates (optional)
print_step "Configuring automatic security updates..."
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Clean up
print_step "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

# Final message
echo ""
echo "========================================================================"
print_status "Server setup completed successfully!"
echo "========================================================================"
echo ""
print_status "Installed software:"
echo "  ✓ ZSH with Oh My Zsh"
echo "  ✓ Neovim with basic configuration"
echo "  ✓ Docker and Docker Compose"
echo "  ✓ Node.js and npm"
echo "  ✓ Python 3 and pip"
echo "  ✓ Essential development tools"
echo "  ✓ Security tools (UFW, fail2ban)"
echo "  ✓ Modern CLI tools (bat, exa, ripgrep, etc.)"
echo ""
print_warning "Please log out and log back in for all changes to take effect."
print_warning "Run 'chsh -s \$(which zsh)' to set ZSH as your default shell."
print_status "Use 'sysinfo' command to display system information anytime."
echo ""
echo "========================================================================"
echo "                              Love u!                                   "
echo "========================================================================"