# Audio Files for Git Hook Laugh Track System

This directory contains audio files or references to laugh tracks that will be played when commits are made.

## Supported Formats

The system supports the following audio formats:
- WAV (recommended for cross-platform compatibility)
- MP3
- OGG
- M4A

## Audio Sources

### Local Files
Place your own laugh track audio files in this directory. The system will randomly select from available files.

### Online References
If no local files are available, the system falls back to online audio sources. These are configured in the `post-commit` script.

## Adding Your Own Laugh Tracks

1. Download laugh track audio files in supported formats
2. Place them in this `audio/` directory
3. The system will automatically detect and use them

## Popular Sitcom Laugh Track Sources

For legal compliance, we recommend using royalty-free or public domain laugh tracks:

- Freesound.org - Community-driven audio library
- Zapsplat.com - Free sound effects (registration required)
- BBC Sound Effects Library - Many public domain effects
- YouTube Audio Library - Royalty-free audio

## Sample Files

To get started quickly, you can download sample laugh tracks:

```bash
# Example commands to download sample audio (run from this directory)
curl -L "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav" -o "applause-1.wav"
curl -L "https://www.pacdv.com/sounds/applause_sounds/applause-8.wav" -o "applause-2.wav"
```

Note: Always respect copyright and licensing when downloading audio files.

## File Naming

Files can be named anything, but consider using descriptive names:
- `sitcom-laugh-1.wav`
- `applause-short.mp3`
- `chuckle.wav`
- `big-laugh.wav`

The system will randomly select from all available files in this directory.