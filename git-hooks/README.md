# Git Hook Laugh Track System 🎭

A fun Git hook system that plays sitcom laugh tracks when you make commits, adding a touch of humor to your development workflow!

## Features

- 🎵 **Cross-platform support** - Works on Windows, macOS, and Linux
- 🎲 **Random selection** - Plays different laugh tracks randomly
- ⚙️ **Configurable** - Easy to enable/disable and customize
- 🔄 **Fallback handling** - Gracefully handles systems without audio support
- 📁 **Local and online audio** - Supports both local files and online sources
- 🚀 **Easy installation** - One-command setup with automated installer

## Quick Start

1. **Install the system:**
   ```bash
   cd /path/to/your/git/repo
   /path/to/git-hooks/install.sh
   ```

2. **Make a commit to test:**
   ```bash
   git add .
   git commit -m "Testing laugh track system"
   # 🎵 You should hear a laugh track!
   ```

3. **Enjoy the entertainment!** Every commit will now be accompanied by a random laugh track.

## Installation

### Automatic Installation

Run the installation script from within any Git repository:

```bash
./git-hooks/install.sh
```

The installer will:
- Check if you're in a Git repository
- Backup any existing post-commit hook
- Install the laugh track system
- Copy configuration files
- Test your system's audio capabilities

### Manual Installation

1. Copy `post-commit` to `.git/hooks/post-commit`
2. Make it executable: `chmod +x .git/hooks/post-commit`
3. Copy `config.json` to `.git/git-hooks/config.json`
4. Optionally copy audio files to `.git/git-hooks/audio/`

## Configuration

Edit `.git/git-hooks/config.json` to customize the behavior:

```json
{
  "enabled": true,
  "volume": 50,
  "description": "Configuration for Git Hook Laugh Track System"
}
```

### Options

- `enabled` (boolean): Set to `false` to disable laugh tracks
- `volume` (number): Volume level 0-100 (for documentation - actual volume control depends on system)

## Audio Files

### Local Audio Files

Place your own laugh track files in `.git/git-hooks/audio/`:

- Supported formats: WAV, MP3, OGG, M4A
- Files are selected randomly
- WAV format recommended for best compatibility

### Online Fallback

If no local files are found, the system uses online audio sources as fallback.

### Adding Your Own Laugh Tracks

1. Find royalty-free laugh tracks from sources like:
   - Freesound.org
   - Zapsplat.com
   - BBC Sound Effects Library
   - YouTube Audio Library

2. Download them to `.git/git-hooks/audio/`
3. The system will automatically use them

## Platform Support

### macOS
- Uses `afplay` (built-in)
- Supports all common audio formats

### Linux
- Tries multiple audio players in order:
  - `paplay` (PulseAudio)
  - `aplay` (ALSA)
  - `mpg123` (MP3 player)
  - `play` (SoX)

### Windows
- Uses PowerShell's `Media.SoundPlayer`
- Works with Git Bash, WSL, and PowerShell

## Troubleshooting

### No Audio Playing

1. **Check if enabled:**
   ```bash
   cat .git/git-hooks/config.json
   # Ensure "enabled": true
   ```

2. **Check audio system:**
   - macOS: Ensure system volume is up
   - Linux: Install audio utilities: `sudo apt install pulseaudio-utils` or `sudo apt install alsa-utils`
   - Windows: Ensure PowerShell can access audio

3. **Test hook manually:**
   ```bash
   .git/hooks/post-commit
   ```

### Permission Errors

Make sure the hook is executable:
```bash
chmod +x .git/hooks/post-commit
```

### Hook Not Running

Check if other post-commit hooks exist:
```bash
ls -la .git/hooks/post-commit*
```

## Uninstalling

Run the uninstall script:

```bash
./git-hooks/uninstall.sh
```

Or manually:
```bash
rm .git/hooks/post-commit
rm -rf .git/git-hooks
```

## Security Notes

- The system only downloads audio from predefined safe sources
- All downloads go to temporary files that are cleaned up
- No executable code is downloaded or executed
- Audio playback is non-blocking and won't interfere with Git operations

## Customization

### Adding More Online Sources

Edit the `get_random_laugh_track()` function in `post-commit` to add more URLs:

```bash
local laugh_tracks=(
    "https://example.com/laugh1.wav"
    "https://example.com/laugh2.wav"
    # Add more URLs here
)
```

### Changing Audio Players

Modify the `detect_os()` function to use different audio players for your system.

## FAQ

**Q: Will this slow down my commits?**
A: No! Audio playback runs in the background and doesn't block Git operations.

**Q: Can I use this in a team repository?**
A: Each developer needs to install it individually. The hooks are not part of the repository itself.

**Q: What if I don't have audio on my system?**
A: The system detects this and silently exits without errors.

**Q: Can I use custom laugh tracks?**
A: Yes! Just place your audio files in `.git/git-hooks/audio/`.

## Contributing

Feel free to submit issues and pull requests to improve the system!

## License

This project is open source. Please respect copyright when using audio files.

---

Happy coding with a smile! 😄🎵