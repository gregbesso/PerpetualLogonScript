# Tremor Video Login Script 001
# Created 2016, 07-20
# Last Modified 2017-02-27, adding wallpaper check + refresh for IT folks only
# Last Modified 2017,01-06 - only remap drives if they exist. commented out verbose if for the XML portion.
# What it does...
# maps H: and R: drives for the user

# variables to be used during drive check/mapping...
$thisUser = $env:username
$global:lsThisComputer = $env:computername
$global:lsLoginTime = Get-Date
$global:lsContinue = $True
$rightNow = Get-Date
$hRoot = '\\domainControllerOrDFSPath\data\users'
$rRoot = '\\domainControllerOrDFSPath\data'
$global:lsEmailServer = 'smtpServerName.domain.int'
$global:lsEmailFrom = 'noreply@tremorvideo.com'
$emailBody = ''
$emailTo = 'greg@domain.com'
$emailFrom = 'noreply@domain.com'
$emailSubject = 'Login Script'
$verboseMode = $true # set to $false for normal use

# disconnect and then remap drives...
Try {
    If (Test-Path "$hRoot\$thisUser") {
    	Net Use H: /d /Y
    	Net Use R: /d /Y
    	Net Use H: "$hRoot\$thisUser" /persistent:yes
    	Net Use R: "$rRoot" /persistent:yes
    }
} Catch {}



#
# START: dot source perpetual logon script section...
#
    While ($global:lsContinue -eq $True) {
        . "\\domainControllerOrDFSPath\NETLOGON\loginScriptDotSource.ps1"                
    }
#
# END: dot source perpetual logon script section
#