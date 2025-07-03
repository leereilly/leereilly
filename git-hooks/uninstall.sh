#!/bin/bash

# Git Hook Laugh Track System - Uninstall Script
# Removes the post-commit hook and cleans up files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Remove the post-commit hook
remove_hook() {
    local git_dir=$(git rev-parse --git-dir)
    local post_commit_hook="$git_dir/hooks/post-commit"
    
    if [[ -f "$post_commit_hook" ]]; then
        # Check if it's our laugh track hook
        if grep -q "Git Hook: Post-Commit Laugh Track Player" "$post_commit_hook" 2>/dev/null; then
            print_status "Removing laugh track post-commit hook..."
            rm "$post_commit_hook"
            print_status "Post-commit hook removed successfully!"
        else
            print_warning "Post-commit hook exists but doesn't appear to be the laugh track system."
            print_warning "Hook location: $post_commit_hook"
            echo -n "Do you want to remove it anyway? (y/N): "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                rm "$post_commit_hook"
                print_status "Post-commit hook removed."
            else
                print_status "Post-commit hook left unchanged."
            fi
        fi
    else
        print_warning "No post-commit hook found to remove."
    fi
    
    # Check for backup files
    local backup_files=("$git_dir/hooks/post-commit.backup."*)
    if [[ -f "${backup_files[0]}" ]]; then
        print_status "Found backup files:"
        for backup in "${backup_files[@]}"; do
            if [[ -f "$backup" ]]; then
                echo "  - $(basename "$backup")"
            fi
        done
        echo -n "Do you want to restore the most recent backup? (y/N): "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            # Find the most recent backup
            local latest_backup=$(ls -t "$git_dir/hooks/post-commit.backup."* 2>/dev/null | head -1)
            if [[ -f "$latest_backup" ]]; then
                cp "$latest_backup" "$post_commit_hook"
                chmod +x "$post_commit_hook"
                print_status "Restored backup: $(basename "$latest_backup")"
            fi
        fi
    fi
}

# Clean up configuration and audio files
cleanup_files() {
    local git_dir=$(git rev-parse --git-dir)
    local git_hooks_dir="$git_dir/git-hooks"
    
    if [[ -d "$git_hooks_dir" ]]; then
        echo -n "Do you want to remove configuration and audio files? (y/N): "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            print_status "Removing configuration and audio files..."
            rm -rf "$git_hooks_dir"
            print_status "Configuration and audio files removed."
        else
            print_status "Configuration and audio files preserved at: $git_hooks_dir"
        fi
    fi
}

# Main uninstall function
main() {
    print_status "Git Hook Laugh Track System - Uninstall"
    print_status "========================================"
    
    # Check if we're in a git repository
    check_git_repo
    
    # Remove the hook
    remove_hook
    
    # Clean up files
    cleanup_files
    
    print_status ""
    print_status "Uninstall complete! 👋"
    print_status ""
    print_status "The laugh track system has been removed from this repository."
    print_status "To reinstall, run: ./git-hooks/install.sh"
}

# Run main function
main "$@"