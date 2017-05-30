<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>
#Requires -RunAsAdministrator

[CmdletBinding()]

param (
    [Parameter(Mandatory)]
    [String[]][Alias("Server")]
    $ComputerName
)

BEGIN {
    #Funcion para crear objetos
    function New-GUline {
        param (
            [String]$Usuarios = $Null,
            [String]$Computer ,
            [String]$Grupo = $null,
            [String]$Estado
        )
        $Property = @{
            Usuarios = $Usuarios
            Servidor = $Computer
            Estado   = $estado
            Grupo    = $Grupo     
        }
        $Object = New-Object PSobject -Property $Property
        Write-Output $Object
    }
    
    function Parsear($String) {
        $String.split(",")[1].trimstart("Name=").trim('"')
    }
}

PROCESS {
    Foreach ($Computer in $ComputerName) {
        Try {
            
            #Hace un query a cada equipo filtrando los grupos Administradores locales
            $Wmi = Get-WmiObject -class Win32_GroupUser -ComputerName $Computer -ErrorAction Stop |
            Where-Object {  $_.groupcomponent -match '"Administra[t|d]or[a-z]{0,3}"$' -and $_.groupcomponent -match $Computer }
            $usuarios = @()

            $wmi | ForEach-Object {
                #Parsea string para obtener los usuarios y grupos
                $usuarios =  Parsear($_.partcomponent)
                $Grupo = Parsear($_.groupcomponent)
                #Genera objeto y lo imprime
                New-GUline  -Usuarios $usuarios -Grupo $Grupo -Computer $Computer -Estado "Online"
            }   
        }
        catch {
            #Genera objeto y lo imprime con su estado
            New-GUline  -Computer $Computer -Estado "Offline"
        }
    }
}

