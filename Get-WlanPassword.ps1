[CmdletBinding()]
param (  )

BEGIN {

    #Varian valores de matcheo dependiendo del idioma del SO
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
        }
        
        $array_objects = New-Object System.Collections.Generic.List[System.Object]
}

PROCESS { 
    $Profiles = netsh wlan show profiles | 
        Select-String -Pattern $Matcher[$language].Profile | 
        ForEach-Object {
            $_.ToString().split(":")[1].trimstart()
        }
    
    IF ($Profiles) {
        Foreach ($ssid in $Profiles) {
            $Password = netsh wlan show profiles $ssid key = clear | select-string -Pattern $Matcher[$language].Password

            $Property = @{
                SSID = $ssid
                Password = $Password.line.ToString().Split(":")[1].TrimStart()
            }

            $Object = New-Object PSObject -Property $Property
            $array_objects.Add($Object)
        }
    }
    
}

END {
            
        Write-Output -InputObject $array_objects
    
 }

