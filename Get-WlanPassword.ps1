<#
    .SYNOPSIS
        Gets the password of all local SSID
    
    .DESCRIPTION
        The Get-WlanPassword cmdlet gets the password of all SSID that are storaged on the computer.

    .EXAMPLE
        Get-WlanPassword
    
    .EXAMPLE
        Invoke-Command -ComputerName "Contoso-PC" -Command { Get-WlanPassword } -Credential (Get-Credential)

        This Command gets the password of ssid that are storaged in the remote computer "Consoto-PC"
        
#>

[CmdletBinding()]

param ()

process { 

    $language = (Get-UICulture).name.substring(0, 2)

    $Matcher = @{  
        es = @{ 
            Profile = "Perfil de todos los usuarios"
            Password = "Contenido de la clave" 
        }
        en = @{
            Profile = "All User Profiles" 
            Password = "Key Content" 
        } 
    } #end of hashtable
        
    $array_objects = New-Object System.Collections.Generic.List[System.Object]

    $Profiles = netsh wlan show profiles | 
        Select-String -Pattern $Matcher[$language].Profile | 
        ForEach-Object {
        $_.ToString().split(":")[1].trimstart()
    } #end of foreach
    

    IF ($Profiles) {
        Foreach ($ssid in $Profiles) {
            $Password = netsh wlan show profiles $ssid key = clear | select-string -Pattern $Matcher[$language].Password
            
            $Property = @{
                SSID = $ssid   
            }
            IF ($null -eq $Password) {
                $Property.Password = $Null 
            }
            else {
                $Property.password = $Password.line.ToString().Split(":")[1].TrimStart()
            }

            $Object = New-Object PSObject -Property $Property
            $array_objects.Add($Object)
        } #end of Foreach
    } #end of IF
    
    Write-Output -InputObject $array_objects
}

