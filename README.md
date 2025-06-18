# Bing Wallpaper Download and Set Script
A zero-dependency PowerShell script that automatically downloads the daily Bing wallpaper and sets it as your Windows desktop background.

## Features
- **Downloads today's Bing daily wallpaper** for a specified or auto-detected region.
- **Sets the downloaded image as your desktop wallpaper** automatically.
- **Supports multiple resolutions** (including UHD) and auto-detects your screen size if set to `auto`.
- **Cleans up old wallpapers** in your chosen folder before saving the new one.
- **Customizable download folder, locale, and resolution**.

## ⚠️ Warning ⚠️
**This script deletes all `.jpg` images in the chosen download folder before saving the new Bing wallpaper.**  
Make sure the `-DownloadFolder` *and* the default `%USERPROFILE%\Pictures\BingWallpapers` does **not** contain any images you wish to keep.

## Usage
```powershell
.\Autobing-Desktop.ps1 [-Locale <locale>] [-Resolution <resolution>] [-DownloadFolder <path>]
````

### Parameters

- `-Locale`  
    The Bing region/market to fetch the image from.  
    **Default**: `auto` (uses `en-US` if not specified)  
    **Supported values** (examples):
    
    - `en-US` (United States, English)
    - `ja-JP` (Japan)
    - `fr-FR` (France)
    - ... _(see [full list](https://github.com/joshkaspar/AutoBing-Desktop/blob/main/AutoBing-Desktop.ps1#L04-L42) in script source)_
- `-Resolution`  
    The image resolution to download.  
    **Default**: `auto` (auto-detects your screen)  
    **Supported values**:
    
    - `UHD`
    - `1920x1200`
    - `1920x1080`
    - `1366x768`
    - ... _(see [full list](https://github.com/joshkaspar/AutoBing-Desktop/blob/main/AutoBing-Desktop.ps1/#L48-L63) in script source)_
- `-DownloadFolder`  
    The folder to save Bing wallpapers.  
    **Default**: `%USERPROFILE%\Pictures\BingWallpapers`
    

## Requirements

- **Windows OS**
- **PowerShell 5+** (pre-installed on Windows 10/11)
- **Internet connection** (to download Bing image)

## Notes

- The script uses `user32.dll` to set the wallpaper and works on standard Windows 10/11 desktops.
- If you encounter "Execution Policy" errors, you may need to allow running scripts:
    
    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
    ```
    
- Running as Administrator is not required.
- Downloaded wallpapers are saved with the format: `YYYY-MM-DD_RESOLUTION.jpg` (Example: `2025-06-18_1920x1080.jpg`)

## Automation

To run this script daily, you can set up a **Windows Task Scheduler task**:
```
Program/script:  powershell.exe
Add arguments:   -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\path\to\your\Autobing-Desktop.ps1"
```

## Credits & License

- Based on [WinDesktop-Bing-wallpapers by Tim van de Kamp](https://github.com/timothymctim/Bing-wallpapers) and [Grant Hendricks' fork](https://github.com/gnhen/WinDesktop-Bing-wallpapers)
- Combined and extended by [Josh Kaspar](https://github.com/joshkaspar)
- Licensed under the MIT License — see `LICENSE` for details
- This script is provided for personal use. Bing wallpapers are property of Microsoft Corporation.
