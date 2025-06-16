# AutoBing-Desktop
A lightweight PowerShell script that automatically fetches Bing’s image of the day, downloads it in your preferred resolution and region, sets it as your desktop wallpaper.

## Features

📥 Downloads Bing’s daily wallpaper in UHD or a resolution of your choice  
🧭 Supports regional variations (e.g. en-US, ja-JP, etc.)  
💻 Auto-detects screen resolution when desired  
✅ Can set the downloaded image as your desktop wallpaper  

## Usage

```powershell
.\AutoBing-Desktop.ps1 -Region 'en-US' -Resolution 'auto' -SetWallpaper
```

### Optional parameters

* `-Region` — Bing market code (e.g., `en-US`, `fr-FR`, `ja-JP`)
* `-Resolution` — image resolution or `auto`
* `-SetWallpaper` — apply the image to your desktop
* `-KeepOld` — keep previously downloaded images
* `-Files` — how many days of images to download (max: 8)

## Credits

* Based on [WinDesktop-Bing-wallpapers by Tim van de Kamp](https://github.com/user1/original-script1) and [Grant Hendricks' fork](https://github.com/gnhen/WinDesktop-Bing-wallpapers)
* Combined by [Josh Kaspar](https://github.com/joshkaspar)
* Licensed under the MIT License — see `LICENSE` for details


