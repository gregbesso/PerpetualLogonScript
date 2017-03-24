#
#
#
#
# START while loop contents...

# START functions declaration...
function Set-DesktopWallpaper() {
# from: http://www.culham.net/powershell/changing-desktop-wallpaper-using-windows-powershell/
# 0: Tile 1: Center 2: Stretch 3: No Change

    Param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [string]$lsWallpaperLocalPath
    )

    If ($lsWallpaperLocalPath.Length -gt 0) {
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    using Microsoft.Win32;
    namespace Wallpaper
    {
        public enum Style : int
        {
            Tile, Center, Stretch, NoChange
        }
        public class Setter {
            public const int SetDesktopWallpaper = 20;
            public const int UpdateIniFile = 0x01;
            public const int SendWinIniChange = 0x02;
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
            private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
            public static void SetWallpaper ( string path, Wallpaper.Style style ) {
                SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
            RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
            switch( style )
            {
                case Style.Stretch :
                    key.SetValue(@"WallpaperStyle", "2") ;
                    key.SetValue(@"TileWallpaper", "0") ;
                break;
                case Style.Center :
                    key.SetValue(@"WallpaperStyle", "1") ;
                    key.SetValue(@"TileWallpaper", "0") ;
                break;
                case Style.Tile :
                    key.SetValue(@"WallpaperStyle", "1") ;
                    key.SetValue(@"TileWallpaper", "1") ;
                break;
                case Style.NoChange :
                break;
            }
        key.Close();
        }
    }
}
"@
    # And this part of the script is pretty much the same. Do a quick check on the resolution and choose a wallpaper based on the result

    [Wallpaper.Setter]::SetWallpaper( "$lsWallpaperLocalPath", 1 )   

    }
}

# END functions declaration



$lsSleepTimer = 3600;

# START only if IT admin (temporary)...
#If (($thisUser -eq 'gbesso') -Or ($thisUser -eq 'gbessotest')) {

    # START excluding any of the contents if the login is on a server...
    $thisOS = Get-WMIObject Win32_OperatingSystem -ComputerName $global:lsThisComputer | select-object Description,Caption,OSArchitecture,ServicePackMajorVersion

    If (($thisOS.Caption -Like '*Server*') -eq $False) {        
        $global:lsContinue = $True;
        $lsWallpaperFile = 'newWallpaper1920-1080.jpg'
        $lsWallpaperLocalPath = "C:\PSManage\Screensaver\Images\$lsWallpaperFile"
        $lsWallpaperSourcePath = '\\server\share\Wallpaper'
        $lsWallpaperUpdate = $False;
        $lsEmail = $False;      

        # manual exception to exclude a single user machine from the process...
        If ($global:lsThisComputer -eq 'SOMEUSER-LP') {
          $lsWallpaperUpdate = $False;  
        }

        If ($lsWallpaperUpdate -eq $True) {
            $getWallpaper = (Get-ItemProperty "HKCU:\Control Panel\Desktop" Wallpaper).WallPaper 

            If ($lsWallpaperLocalPath -ne $getWallpaper) {
                # do stuff to apply the desired wallpaper setting to the user...
                # first copy the file locally if not yet there...
                If (!(Test-Path "c:\PSManage\Screensaver")) { New-Item -ItemType Directory -Path "C:\PSManage\Screensaver" }
                If (!(Test-Path "c:\PSManage\Screensaver\Images")) { New-Item -ItemType Directory -Path "C:\PSManage\Screensaver\Images" }
                If (!(Test-Path "$lsWallpaperLocalPath")) {
                    Copy-Item -Path "$lsWallpaperSourcePath\$lsWallpaperFile" -Destination "$lsWallpaperLocalPath" -Force
                    If ((!(Test-Path "\\server\share$\wallpaperCopied\$global:lsThisComputer.xml")) -And (Test-Path "$lsWallpaperLocalPath")) {
                        Try {
                            $getResolution = Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight
                            $lsScreenWidth = $getResolution.ScreenWidth
                            $lsScreenHeight = $getResolution.ScreenHeight                            
                            $object1a = [pscustomobject]@{
                                lsThisComputer=$global:lsThisComputer;
                                lsScreenWidth=$lsScreenWidth;
                                lsScreenHeight=$lsScreenHeight;
                                lsWallpaperLocalPath=$lsWallpaperLocalPath;              
                            }
                            $object1a | Export-Clixml "\\server\share$\wallpaperCopied\$global:lsThisComputer.xml" -Force
                            } Catch {}
                    }            
                }

                # second check time on local system, if it's time to make the change yet...
                $timeCheck = Get-Date
                If (($timeCheck.Year -ge 2017) -And($timeCheck.Month -ge 3) -And($timeCheck.Day -ge 7) -And($timeCheck.Hour -ge 8)) {                   
                    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name ScreenSaveTimeOut -value '900'
                    Set-DesktopWallpaper -lsWallpaperLocalPath "$lsWallpaperLocalPath"
                    If (!(Test-Path "\\server\share$\wallpaperApplied\$global:lsThisComputer.xml")) {
                        Try {
                            $getResolution = Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight
                            $lsScreenWidth = $getResolution.ScreenWidth
                            $lsScreenHeight = $getResolution.ScreenHeight
                            $object1a = [pscustomobject]@{
                                lsThisComputer=$global:lsThisComputer;
                                lsScreenWidth=$lsScreenWidth;
                                lsScreenHeight=$lsScreenHeight;
                                lsWallpaperLocalPath=$lsWallpaperLocalPath;              
                            }
                            $object1a | Export-Clixml "\\server\share$\wallpaperApplied\$global:lsThisComputer.xml" -Force
                        } Catch {}                        
                    }
                }
            } Else {
                    rundll32.exe user32.dll, UpdatePerUserSystemParameters
                    rundll32.exe user32.dll, UpdatePerUserSystemParameters
                    rundll32.exe user32.dll, UpdatePerUserSystemParameters
                    rundll32.exe user32.dll, UpdatePerUserSystemParameters
                    rundll32.exe user32.dll, UpdatePerUserSystemParameters
                    rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True
                    rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True
                    rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True
                    rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True
                    rundll32.exe user32.dll,UpdatePerUserSystemParameters 1, True
            }
        }



        # START xml file heartbeat...
        Try {
            $getResolution = Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight
            $lsScreenWidth = $getResolution.ScreenWidth
            $lsScreenHeight = $getResolution.ScreenHeight                            
            $object1a = [pscustomobject]@{
                lsThisComputer=$global:lsThisComputer;
                lsThisUser=$thisUser; 
                lsLoginTime=$rightNow;            
            }
            $object1a | Export-Clixml "\\server\share$\heartbeat\$global:lsThisComputer-$thisUser.xml" -Force
        } Catch {}
        # END xml file heartbeat

    } Else {
        $lsSleepTimer = 5;
        $global:lsContinue = $False;
        $lsEmail = $False;
    }
    # END excluding any of the contents if the login is on a server



    # sleep before repeating/exiting...
   
#}
# END only if IT admin (temporary)

Start-Sleep -Seconds $lsSleepTimer
# END while loop contents
