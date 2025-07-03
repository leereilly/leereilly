#!/bin/bash

# Git Hook Laugh Track System - Test Script
# Tests the laugh track system without making a commit

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
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

# Test if the hook is installed
test_hook_installation() {
    local git_dir=$(git rev-parse --git-dir)
    local post_commit_hook="$git_dir/hooks/post-commit"
    
    print_test "Checking hook installation..."
    
    if [[ -f "$post_commit_hook" ]]; then
        if grep -q "Git Hook: Post-Commit Laugh Track Player" "$post_commit_hook" 2>/dev/null; then
            print_status "✓ Laugh track hook is installed"
            return 0
        else
            print_warning "✗ post-commit hook exists but is not the laugh track system"
            return 1
        fi
    else
        print_error "✗ No post-commit hook found"
        print_status "Run ./git-hooks/install.sh to install the system"
        return 1
    fi
}

# Test configuration
test_configuration() {
    local git_dir=$(git rev-parse --git-dir)
    local config_file="$git_dir/git-hooks/config.json"
    
    print_test "Checking configuration..."
    
    if [[ -f "$config_file" ]]; then
        print_status "✓ Configuration file found"
        
        if command -v python3 >/dev/null 2>&1; then
            local enabled=$(python3 -c "import json; config=json.load(open('$config_file')); print(config.get('enabled', 'unknown'))" 2>/dev/null || echo "unknown")
            if [[ "$enabled" == "True" ]] || [[ "$enabled" == "true" ]]; then
                print_status "✓ Laugh track system is enabled"
            else
                print_warning "✗ Laugh track system is disabled"
                print_status "Edit $config_file and set 'enabled' to true"
            fi
        else
            print_status "→ Configuration exists (cannot parse without Python)"
        fi
    else
        print_warning "✗ Configuration file not found"
        print_status "Expected location: $config_file"
    fi
}

# Test audio capabilities
test_audio_capabilities() {
    print_test "Checking audio capabilities..."
    
    case "$(uname -s)" in
        Darwin)
            if command -v afplay >/dev/null 2>&1; then
                print_status "✓ macOS audio support available (afplay)"
            else
                print_warning "✗ macOS audio player (afplay) not found"
            fi
            ;;
        Linux)
            local found_player=false
            local available_players=()
            
            for player in paplay aplay mpg123 play; do
                if command -v "$player" >/dev/null 2>&1; then
                    available_players+=("$player")
                    found_player=true
                fi
            done
            
            if [[ "$found_player" == true ]]; then
                print_status "✓ Linux audio support available (${available_players[*]})"
            else
                print_warning "✗ No Linux audio players found"
                print_status "Consider installing: pulseaudio-utils, alsa-utils, mpg123, or sox"
                print_status "The system will show visual feedback instead"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            if command -v powershell >/dev/null 2>&1; then
                print_status "✓ Windows audio support available (PowerShell)"
            else
                print_warning "✗ PowerShell not found for Windows audio playback"
            fi
            ;;
        *)
            print_warning "✗ Unsupported operating system: $(uname -s)"
            print_status "The system will show visual feedback instead"
            ;;
    esac
}

# Test audio files
test_audio_files() {
    local git_dir=$(git rev-parse --git-dir)
    local audio_dir="$git_dir/git-hooks/audio"
    
    print_test "Checking audio files..."
    
    if [[ -d "$audio_dir" ]]; then
        local audio_files=()
        for ext in mp3 wav ogg m4a; do
            for file in "$audio_dir"/*."$ext"; do
                if [[ -f "$file" ]]; then
                    audio_files+=("$file")
                fi
            done
        done
        local valid_files=()
        
        for file in "${audio_files[@]}"; do
            if [[ -f "$file" ]]; then
                valid_files+=("$file")
            fi
        done
        
        if [[ ${#valid_files[@]} -gt 0 ]]; then
            print_status "✓ Found ${#valid_files[@]} local audio file(s)"
            for file in "${valid_files[@]}"; do
                print_status "  → $(basename "$file")"
            done
        else
            print_status "→ No local audio files found"
            print_status "  The system will use online fallback sources"
            print_status "  Add .wav, .mp3, .ogg, or .m4a files to: $audio_dir"
        fi
    else
        print_warning "✗ Audio directory not found: $audio_dir"
    fi
}

# Test the hook directly
test_hook_execution() {
    local git_dir=$(git rev-parse --git-dir)
    local post_commit_hook="$git_dir/hooks/post-commit"
    
    print_test "Testing hook execution..."
    
    if [[ -f "$post_commit_hook" ]] && [[ -x "$post_commit_hook" ]]; then
        print_status "Running post-commit hook..."
        echo "---"
        "$post_commit_hook"
        echo "---"
        print_status "✓ Hook executed successfully"
    else
        print_error "✗ Hook is not executable or not found"
    fi
}

# Main test function
main() {
    print_status "Git Hook Laugh Track System - Test Suite"
    print_status "========================================"
    
    # Check if we're in a git repository
    check_git_repo
    
    echo
    test_hook_installation
    
    echo
    test_configuration
    
    echo
    test_audio_capabilities
    
    echo
    test_audio_files
    
    echo
    test_hook_execution
    
    echo
    print_status "Test complete! 🎉"
    print_status ""
    print_status "If you saw output above, the system is working!"
    print_status "Try making a real commit to see it in action."
}

# Run main function
main "$@"