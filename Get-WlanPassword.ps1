<#PSScriptInfo

.VERSION 1.0.3

.GUID b0a6b94b-06dc-4d52-b6dd-35a2cbcf3b09

.AUTHOR JeB94

.COMPANYNAME 

.COPYRIGHT 

.TAGS wlan wifi password SSID

.LICENSEURI 

.PROJECTURI https://github.com/JeB94/PoSh

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 
    .DESCRIPTION
        The Get-WlanPassword cmdlet gets the password of all SSID that are storaged on the computer. 

#> 

[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline)]
    [String[]]
    $ComputerName = $ENV:ComputerName,

    [PSCredential]
    $Credential
)
begin {

    Write-Verbose "[BEGIN  ] Starting $($MyInvocation.MyCommand)"

    $Command = {

        Write-Verbose "[PROCESS] Searching wlan profiles on $Env:ComputerName"
        $Profiles = netsh wlan show profiles

        $ListProfiles = @()

        # Get Profiles
        Foreach ($p in $Profiles) {
            if (($p -split ":")[1] -match "\w+[\w+\s\.]+" ) {
                $ListProfiles += $Matches[0]
            }
        }

        IF ($ListProfiles) {
            Write-Verbose "[PROCESS] Found wlan profiles. Retrieving passwords"

            Foreach ($ssid in $ListProfiles) {

                $counter = 0
                $isPasswordLine = 0
                Write-Verbose "[PROCESS] Getting password of $Ssid"
                $GetPassword = netsh wlan show profiles $ssid key = clear 

                Foreach ($Line in $GetPassword) {
                    if ($Counter -eq 3) {

                        # Get Password
                        if ($isPasswordLine -eq 5) {
                            $Password = ($line -split ":")[1]
                            break
                        }
                        else {
                            $isPasswordLine ++
                        }

                    }
                    elseif ($Line.StartsWith("---")) {
                        $Counter ++ 
                    }
                }
                
                $Property = @{
                    SSID         = $ssid   
                    ComputerName = $Env:ComputerName
                }

                if ($null -ne $Password) {
                
                    $Property.Password = $Password.TrimStart()
                }
                
                $Object = New-Object PSObject -Property $Property
                Write-Output -InputObject $Object

            } #end of Foreach
        }
        else {
            Write-Warning "[$($Env:ComputerName)] Profile not found"
        } # if else
    } # script block
} # begin

process {

    Foreach ($Computer in $ComputerName) {
        Write-Verbose "[PROCESS] Connecting to $Computer"
        $Params = @{
            ComputerName     = $Computer
            ScriptBlock      = $Command
            HideComputerName = $False
        }

        if ($Computer -match "Localhost|$($env:computername)") {
            $Params.Remove("hideComputerName")
            $Params.Remove('ComputerName')
        }
        elseif ($PSBoundParameters.ContainsKey('credential')) {
            $Params.Credential = $Credential
        }

        try {
            Invoke-Command @Params -ErrorAction Stop |  Select-Object ComputerName, SSID, Password
        }
        catch {
            Write-Error $_
        } # try catch
    } # foreach
} # process

end {
    Write-Verbose "[END    ] Ending $($MyInvocation.MyCommand)"
}