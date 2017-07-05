[CmdletBinding()]

param (
    [Parameter(Mandatory,
        ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $Identity
)

process {
    $regPath = "HKLM:\SOFTWARE\microsoft\windows Nt\CurrentVersion\ProfileList\*"

    $Profiles = (Get-ItemProperty $regPath).where( {$_ -match 'S-1-5-21-[\d]+-[\d]+-[\d]+-[\d]+'})

    Foreach ($User in $Identity) {
        Write-Verbose "Processing user $User"
        $UserInfo = $Profiles.Where( {$_.ProfileImagePath -match $User })

        IF (!($UserInfo)) {
            Write-Error "User $User not found."
            Continue
        }
        $RegistryPath = "Registry::HKEY_USERS\{0}\" -f $UserInfo.PSChildName

        IF (!(Test-Path -Path $RegistryPath)) {
            Write-Error "User $User has not logged on windows"
            Continue
        }

        $Output = @{
            User         = $User
            RegistryPath = $RegistryPath
            SID          = $UserInfo.PSChildName
        }

        [PSCustomObject]$Output 
    } # foreach 
} # process