# Bing Wallpaper Downloader & Setter

Param(
    # Get the Bing image of this country
    [ValidateSet(
        'auto',
        'da-DK',  # Denmark
        'de-AT',  # Austria
        'de-CH',  # Switzerland (German)
        'de-DE',  # Germany
        'en-AU',  # Australia
        'en-CA',  # Canada (English)
        'en-GB',  # United Kingdom
        'en-ID',  # Indonesia
        'en-IN',  # India
        'en-MY',  # Malaysia
        'en-NZ',  # New Zealand
        'en-PH',  # Philippines
        'en-US',  # United States (English)
        'en-ZA',  # South Africa
        'es-AR',  # Argentina
        'es-CL',  # Chile
        'es-ES',  # Spain
        'es-MX',  # Mexico
        'es-US',  # United States (Spanish)
        'fi-FI',  # Finland
        'fr-BE',  # Belgium (French)
        'fr-CA',  # Canada (French)
        'fr-CH',  # Switzerland (French)
        'fr-FR',  # France
        'it-IT',  # Italy
        'ja-JP',  # Japan
        'ko-KR',  # Korea
        'nl-BE',  # Belgium (Dutch)
        'nl-NL',  # Netherlands
        'no-NO',  # Norway
        'pl-PL',  # Poland
        'pt-BR',  # Brazil
        'ru-RU',  # Russia
        'sv-SE',  # Sweden
        'tr-TR',  # Türkiye
        'zh-CN',  # China
        'zh-HK',  # Hong Kong
        'zh-TW'   # Taiwan
    )]
    [string]$Locale = 'auto',

    # Resolution of the image to download
    [ValidateSet(
        'auto',
        'UHD',
        '1920x1200',
        '1920x1080',
        '1366x768',
        '1280x768',
        '1024x768',
        '800x600',
        '800x480',
        '768x1280',
        '720x1280',
        '640x480',
        '480x800',
        '400x240',
        '320x240',
        '240x320'
    )]
    [string]$Resolution = 'auto',

    # Destination folder to download the wallpapers to
    [string]$DownloadFolder = (Join-Path ([Environment]::GetFolderPath('MyPictures')) 'BingWallpapers')
)

# Ensure destination folder exists
if (-not (Test-Path -Path $DownloadFolder)) {
    New-Item -ItemType Directory -Path $DownloadFolder -Force | Out-Null
}

function Get-BestResolution {
    param(
        [int]$CurrentWidth,
        [int]$CurrentHeight
    )

    $isLandscape = $CurrentWidth -ge $CurrentHeight

    if ($isLandscape) {
        switch ($CurrentWidth) {
            {$_ -le 640}   { return '640x480' }
            {$_ -le 800}   { return '800x600' }
            {$_ -le 1024}  { return '1024x768' }
            {$_ -le 1280}  { return '1280x768' }
            {$_ -le 1366}  { return '1366x768' }
            {$_ -le 1920}  {
                # decide between the two 1920 variants based on height
                $diff1200 = [Math]::Abs($CurrentHeight - 1200)
                $diff1080 = [Math]::Abs($CurrentHeight - 1080)
                if ($diff1200 -lt $diff1080) {
                    return '1920x1200'
                } else {
                    return '1920x1080'
                }            
				}
            default        { return 'UHD' }
        }
    }
    else {
        switch ($CurrentHeight) {
            {$_ -le 320}   { return '240x320' }
            {$_ -le 800}   { return '480x800' }
            {$_ -le 1280}  { return '720x1280' }
            default        { return '768x1280' }
        }
    }
}

# Auto-detect resolution if needed
if ($Resolution -eq 'auto') {
    Add-Type -AssemblyName System.Windows.Forms
    $primaryScreen = [System.Windows.Forms.Screen]::PrimaryScreen

    Write-Host "Detected screen resolution: $($primaryScreen.Bounds.Width)x$($primaryScreen.Bounds.Height)"

    $Resolution = Get-BestResolution -CurrentWidth $primaryScreen.Bounds.Width -CurrentHeight $primaryScreen.Bounds.Height
    Write-Host "Selected resolution: $Resolution"
}

# Determine market based on locale
$Market = if ($Locale -eq 'auto') { 'en-US' } else { $Locale }

# Fetch Bing image metadata
Write-Host "Fetching Bing image metadata for market: $Market"
$response = Invoke-RestMethod "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$Market"
$imagePath = $response.images[0].url

# Replace resolution in URL
$FinalImagePath = if ($Resolution -eq 'UHD') {
    $imagePath -replace '1920x1080', 'UHD'
} else {
    $imagePath -replace '1920x1080', $Resolution
}

$FullImageUrl = "https://www.bing.com$FinalImagePath"
Write-Host "Image URL: $FullImageUrl"

# Delete previous Bing wallpapers in the folder
Write-Host "Cleaning up old wallpapers..."
Get-ChildItem -Path $DownloadFolder -Filter '*.jpg' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

# Create filename using current date and resolution
$DateString = Get-Date -Format 'yyyy-MM-dd'
$Filename = "${DateString}_${Resolution}.jpg"
$DownloadPath = Join-Path $DownloadFolder $Filename

# Download the image
Write-Host "Downloading wallpaper to: $DownloadPath"
try {
    Invoke-WebRequest -Uri $FullImageUrl -OutFile $DownloadPath -UseBasicParsing
    Write-Host 'Download completed successfully'
} catch {
    Write-Error "Failed to download image: $_"
    exit 1
}

# Set as wallpaper using user32.dll
Write-Host 'Setting as wallpaper...'
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

$result = [Wallpaper]::SystemParametersInfo(20, 0, $DownloadPath, 3)
if ($result) {
    Write-Host 'Wallpaper set successfully!'
} else {
    Write-Error 'Failed to set wallpaper'
}

Write-Host "Script completed. Image saved as: $Filename"
