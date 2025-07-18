# 🚀 Bartus Server Setup Script

**Automated server installation script for Debian Trixie**

This script automatically configures a complete server environment with all essential tools for developers and system administrators.

```
______            _               _____          _        _ _           
| ___ \          | |             |_   _|        | |      | | |          
| |_/ / __ _ _ __| |_ _   _ ___    | | _ __  ___| |_ __ _| | | ___ _ __ 
| ___ \/ _` | '__| __| | | / __|   | || '_ \/ __| __/ _` | | |/ _ \ '__|
| |_/ / (_| | |  | |_| |_| \__ \  _| || | | \__ \ || (_| | | |  __/ |   
\____/ \__,_|_|   \__|\__,_|___/  \___/_| |_|___/\__\__,_|_|_|\___|_|   
```

## 📋 Requirements

- **Debian Trixie** (fresh installation recommended)
- sudo access
- Internet connection

## 🔧 Installation

1. **Download the script:**
```bash
wget https://raw.githubusercontent.com/BrawlsMons/BartusInstaller/main/start.sh
```

2. **Make it executable:**
```bash
chmod +x start.sh
```

3. **Run the script:**
```bash
./start.sh
```

## 📦 What will be installed?

### 🛠️ Development Tools
- **Neovim** - advanced editor with configuration
- **Git** - version control system
- **Node.js & npm** - JavaScript runtime (latest LTS)
- **Python 3 & pip** - with virtualenv and dev tools
- **Rust & Cargo** - Rust compiler with package manager

### 🐚 Shell and Terminal
- **ZSH** - advanced shell
- **Oh My Zsh** - ZSH framework with plugins:
  - `zsh-autosuggestions` - command suggestions
  - `zsh-syntax-highlighting` - syntax highlighting
- **Tmux & Screen** - terminal multiplexers

### 🐳 Containerization
- **Docker** - latest CE version
- **Docker Compose** - container orchestration
- Automatic user addition to docker group

### 🔒 Security
- **UFW Firewall** - configured with basic rules
- **fail2ban** - protection against brute-force attacks
- **SSH** - secure remote access
- **Automatic security updates**

### 🌐 Network and Server Tools
- **nginx** - web server
- **certbot** - SSL/TLS certificates
- **PostgreSQL client** - database client
- **MySQL client** - database client
- **Redis tools** - Redis utilities

### ⚡ Modern CLI Tools
- **bat** - better `cat` with syntax highlighting
- **exa** - modern `ls` with colors
- **ripgrep** - ultra-fast `grep`
- **fd-find** - intuitive `find`
- **jq** - JSON processor
- **httpie** - friendly HTTP client
- **ncdu** - disk usage analyzer

## 🎯 Additional Features

### 📊 `sysinfo` Script
After installation, the `sysinfo` command will be available showing:
- System information (hostname, OS, kernel, uptime)
- Memory and disk status
- Network information
- Docker status
- Number of running processes and users

### 🔧 Useful Aliases
The script automatically adds useful aliases:
```bash
alias vi='nvim'           # Neovim as vi
alias vim='nvim'          # Neovim as vim  
alias python='python3'    # Python 3 as default
alias pip='pip3'          # pip3 as default
alias dc='docker-compose' # Shortcut for docker-compose
alias ll='ls -alF'        # Long file listing
```

### 🎨 Neovim Configuration
Basic configuration includes:
- Line numbering (absolute and relative)
- Smart indentation
- Search highlighting
- System clipboard support
- Useful keyboard shortcuts (leader: space)

## 🔥 After Installation

1. **Log out and log back in** (for user groups)
2. **Set ZSH as default shell:**
```bash
chsh -s $(which zsh)
```
3. **Check system status:**
```bash
sysinfo
```

## 🛡️ Security Configuration

### Firewall (UFW)
- ✅ SSH (port 22)
- ✅ HTTP (port 80)  
- ✅ HTTPS (port 443)
- ❌ All other incoming ports blocked

### fail2ban
- Automatic SSH protection against brute-force attacks
- IP banning after failed login attempts

## 🐛 Troubleshooting

### Docker not working after installation
```bash
# Check service status
sudo systemctl status docker

# Start Docker if not active
sudo systemctl start docker
sudo systemctl enable docker
```

### ZSH not starting automatically
```bash
# Check if ZSH is installed
which zsh

# Set as default shell
chsh -s $(which zsh)
```

### Oh My Zsh issues
```bash
# Reinstall Oh My Zsh
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 📝 Logs

The script displays colored messages:
- 🔵 **[STEP]** - current installation step
- 🟢 **[INFO]** - progress information
- 🟡 **[WARNING]** - warnings
- 🔴 **[ERROR]** - errors

## 🤝 Contributing

If you find a bug or have an improvement idea:
1. Open an Issue
2. Send a Pull Request
3. Contact via Discord/Telegram

## 📄 License

MIT License - feel free to use and modify.

---

**Created with ❤️ for a friend on Debian Trixie**

*Happy coding! 🚀*
