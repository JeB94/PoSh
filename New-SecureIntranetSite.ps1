[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    $uri, 

    [ValidateSet("https", "http")]
    $Type,
        
    [Parameter(Mandatory)]
    $Identity
)

$RegistryPath = "\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\"

IF ($uri -match "^www.[a-z]+") {
    throw "Insert only domain name."
}

$UserPath = .\Get-UserRegistryPath -Identity $identity
$CustomPath = "{0}{1}{2}" -f $UserPath.RegistryPath, $RegistryPath , $uri
     
IF (!(Test-Path -Path $CustomPath )) {
    New-Item -Path $CustomPath | Out-Null
}

Set-ItemProperty -Path $CustomPath -Name $Type -Value 1 -Type DWord