#!/data/data/com.termux/files/usr/bin/bash

# Function to display progress messages
log_message() {
    echo "$1"
    sleep 1
}

# Install initial dependencies
log_message "Installing initial dependencies..."
apt install -y python-pip cowsay figlet proot-distro git wget curl x11-repo termux-x11-nightly tur-repo pulseaudio
pip install lolcat

# Display script information
log_message "CODED BY..."
figlet "D I C E    A I L S" | lolcat

# Prompt for update
read -p "Let's Update First (yes/y/Y or no/n/N): " answer
if [[ "$answer" =~ ^(yes|y|Y)$ ]]; then
    log_message "Updating your system..."
    apt update && apt upgrade -y
    figlet "Update DONE" | lolcat

    # Install Parrot CLI
    log_message "Installing ParrotOS CLI..."
    cd ~
    wget -q https://github.com/LinuxDroidMaster/parrotOS-GUI-proot/archive/refs/heads/main.zip -O parrotOS.zip || {
        echo "Failed to download ParrotOS. Exiting..."
        exit 1
    }
    unzip -o parrotOS.zip
    cd parrotOS-GUI-proot-main || {
        echo "Directory not found. Exiting..."
        exit 1
    }

    chmod +x *
    ./setup-parrot-cli
    figlet "Setup Complete" | lolcat

    # Enter Parrot CLI and execute setup
    log_message "Logging into ParrotOS CLI..."
    parrot -r << 'EOF'
apt update && apt upgrade -y
apt install -y sudo git
chmod +x *
./install-parrot-desktop
EOF
    log_message "ParrotOS Desktop XFCE4 setup complete!"

elif [[ "$answer" =~ ^(no|n|N)$ ]]; then
    log_message "Skipping updates..."
    figlet "DONE" | lolcat
else
    log_message "Invalid input. Please enter yes/y/Y or no/n/N."
    exit 1
fi

log_message "Script execution completed!"
