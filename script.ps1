Invoke-WebRequest -Uri "https://docs.google.com/uc?export=download&id=1PbQQ4p2jAoFUQWZRDgsR-PPBgxYxuqsZ" -OutFile "$dir\image.png"
Function Set-WallPaper {
 param (
    [parameter(Mandatory=$True)]
    # Provide path to image
    [string]$Image,
    # Provide wallpaper style that you would like applied
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"6"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}
Set-WallPaper -Image "C:\image.png" -Style Center

Add-Type -AssemblyName presentationCore
$filepath = "$dir\video.mp4"

#Here we use your code to get the duration of the video
$wmplayer = New-Object System.Windows.Media.MediaPlayer
$wmplayer.Open($filepath)
Start-Sleep 2 
$duration = $wmplayer.NaturalDuration.TimeSpan.Seconds
$wmplayer.Close()

#Here we just open media player and play the file, with an extra second for it to start playing
$proc = Start-process -FilePath wmplayer.exe -ArgumentList $filepath -PassThru
Start-Sleep ($duration + 1)

#Here we kill the media player
Stop-Process $proc.Id -force

Write-Host $duration
