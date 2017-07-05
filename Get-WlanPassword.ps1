<#PSScriptInfo

.VERSION 1.0.2

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

    $Command = {

        $language = (Get-UICulture).name.substring(0, 2)

        $Matcher = @{  
            es = @{ 
                Profile  = "Perfil de todos los usuarios"
                Password = "Contenido de la clave" 
            }
            en = @{
                Profile  = "All User Profiles" 
                Password = "Key Content" 
            } 
        } #end of hashtable
        
        Write-Verbose "Searching wlan profiles on $Env:ComputerName"
        $Profiles = netsh wlan show profiles | 
            Select-String -Pattern $Matcher[$language].Profile | 
            ForEach-Object {
            $_.ToString().split(":")[1].trimstart()
        } #end of foreach
    

        IF ($Profiles) {
            Write-Verbose "Found wlan profiles. Retrieving passwords"
            Foreach ($ssid in $Profiles) {
                Write-Verbose "Getting password of $Ssid"
                $Password = netsh wlan show profiles $ssid key = clear | select-string -Pattern $Matcher[$language].Password
            
                $Property = @{
                    SSID         = $ssid   
                    ComputerName = $Env:ComputerName
                }
            
                IF ($null -eq $Password) {
                    $Property.Password = $Null 
                }
                else {
                    $Property.Password = $Password.line.ToString().Split(":")[1].TrimStart()
                }

                $Object = New-Object PSObject -Property $Property
                Write-Output -InputObject $Object
            } #end of Foreach
        }
        else {
            Write-Warning "[$($Env:ComputerName)] Profile not found"
        } # if else
    }
} # begin

process {

    Foreach ($Computer in $ComputerName) {
        Write-Verbose "Connecting to $Computer"
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