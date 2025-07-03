#!/bin/bash

# Git Hook Laugh Track System - Installation Script
# Installs the post-commit hook for playing sitcom laugh tracks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_error "Not in a Git repository. Please run this script from within a Git repository."
        exit 1
    fi
}

# Check if hooks directory exists
setup_hooks_directory() {
    local git_dir=$(git rev-parse --git-dir)
    local hooks_dir="$git_dir/hooks"
    
    if [[ ! -d "$hooks_dir" ]]; then
        print_status "Creating hooks directory: $hooks_dir"
        mkdir -p "$hooks_dir"
    fi
    
    echo "$hooks_dir"
}

# Install the post-commit hook
install_hook() {
    local hooks_dir="$1"
    local post_commit_hook="$hooks_dir/post-commit"
    local source_hook="$SCRIPT_DIR/post-commit"
    
    # Check if post-commit hook already exists
    if [[ -f "$post_commit_hook" ]]; then
        print_warning "post-commit hook already exists at: $post_commit_hook"
        echo -n "Do you want to backup the existing hook and install the laugh track system? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled."
            exit 0
        fi
        
        # Backup existing hook
        local backup_file="$post_commit_hook.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backing up existing hook to: $backup_file"
        cp "$post_commit_hook" "$backup_file"
    fi
    
    # Copy the laugh track hook
    print_status "Installing laugh track post-commit hook..."
    cp "$source_hook" "$post_commit_hook"
    chmod +x "$post_commit_hook"
    
    print_status "Post-commit hook installed successfully!"
}

# Copy configuration and audio files
setup_config() {
    local git_dir=$(git rev-parse --git-dir)
    local git_hooks_dir="$git_dir/git-hooks"
    
    # Create git-hooks directory in .git
    if [[ ! -d "$git_hooks_dir" ]]; then
        print_status "Creating git-hooks directory: $git_hooks_dir"
        mkdir -p "$git_hooks_dir/audio"
    fi
    
    # Copy configuration
    if [[ -f "$SCRIPT_DIR/config.json" ]]; then
        cp "$SCRIPT_DIR/config.json" "$git_hooks_dir/"
        print_status "Configuration file copied to: $git_hooks_dir/config.json"
    fi
    
    # Copy any audio files
    if [[ -d "$SCRIPT_DIR/audio" ]] && [[ -n "$(ls -A "$SCRIPT_DIR/audio" 2>/dev/null)" ]]; then
        cp "$SCRIPT_DIR/audio"/* "$git_hooks_dir/audio/" 2>/dev/null || true
        print_status "Audio files copied to: $git_hooks_dir/audio/"
    fi
}

# Test audio capabilities
test_audio() {
    print_status "Testing audio capabilities..."
    
    case "$(uname -s)" in
        Darwin)
            if command -v afplay >/dev/null 2>&1; then
                print_status "✓ macOS audio support detected (afplay)"
            else
                print_warning "✗ macOS audio player (afplay) not found"
            fi
            ;;
        Linux)
            local found_player=false
            for player in paplay aplay mpg123 play; do
                if command -v "$player" >/dev/null 2>&1; then
                    print_status "✓ Linux audio support detected ($player)"
                    found_player=true
                    break
                fi
            done
            if [[ "$found_player" == false ]]; then
                print_warning "✗ No Linux audio players found. Consider installing: pulseaudio-utils, alsa-utils, mpg123, or sox"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            if command -v powershell >/dev/null 2>&1; then
                print_status "✓ Windows audio support detected (PowerShell)"
            else
                print_warning "✗ PowerShell not found for Windows audio playback"
            fi
            ;;
        *)
            print_warning "✗ Unsupported operating system for audio playback"
            ;;
    esac
}

# Main installation function
main() {
    print_status "Git Hook Laugh Track System - Installation"
    print_status "=========================================="
    
    # Check if we're in a git repository
    check_git_repo
    
    # Setup hooks directory
    local hooks_dir
    hooks_dir=$(setup_hooks_directory)
    
    # Install the hook
    install_hook "$hooks_dir"
    
    # Setup configuration
    setup_config
    
    # Test audio capabilities
    test_audio
    
    print_status ""
    print_status "Installation complete! 🎉"
    print_status ""
    print_status "The laugh track system is now active. Try making a commit to test it!"
    print_status ""
    print_status "Configuration:"
    print_status "  - Config file: .git/git-hooks/config.json"
    print_status "  - Audio files: .git/git-hooks/audio/"
    print_status ""
    print_status "To disable: edit config.json and set 'enabled' to false"
    print_status "To uninstall: remove .git/hooks/post-commit"
    
}

# Run main function
main "$@"