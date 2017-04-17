Function Get-UserRegistryPath {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        $Identity
    )

    $regPath = "HKLM:\SOFTWARE\microsoft\windows Nt\CurrentVersion\ProfileList\*"

    $Profiles = (Get-ItemProperty $regPath).where( {$_ -match 'S-1-5-21-[\d]+-[\d]+-[\d]+-[\d]+'})

    $User = $Profiles.Where( {$_.ProfileImagePath -match $Identity })

    IF (!($User)) {
        throw "User not found."
    }
    $PathUser = "Registry::HKEY_USERS\{0}\" -f $User.PSChildName

    IF (!(Test-Path -Path $PathUser)) {
        throw "User not logged to windows"
    }

    Write-Output $PathUser 
}

Function New-SecureSiteIntrent {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $uri, 

        [ValidateSet("https","http")]
        $Type,
        
        [Parameter(Mandatory)]
        $Identity
    )

    $RegistryPath = "\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\"

    IF ($uri -match "^www.[a-z]+") {
        throw "Insert only domain name."
    }

    $UserPath = Get-UserRegistryPath -Identity $identity
    $CustomPath = "{0}{1}{2}" -f $UserPath, $RegistryPath , $uri
     
    IF (!(Test-Path -Path $CustomPath )) {
        New-Item -Path $CustomPath | Out-Null
    }

    Set-ItemProperty -Path $CustomPath -Name $Type -Value 1 -Type DWord
}