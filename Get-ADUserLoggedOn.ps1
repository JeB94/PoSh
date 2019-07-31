<#
    .SYNOPSIS
        Script que devuelve en que equipo se encuentra un usuario
    
    .DESCRIPTION
        Este Script busca en qué equipo esta logeado determinado usuario. Se pueden buscar mas de un usuario.
        Para el parametro User, se debe utilizar si el SamAccountName del usuario. Este se puede encontrar haciendo una busqueda del usuario en el AD.
        El SamAccountName es el string que se utiliza para iniciar sesión en windows.

    .PARAMETER Identity
        Especifica nombre de usuario. Se utiliza el SamAccountName. Acepta mas de un usuario.

    .PARAMETER SearchBase
        Especifica OU donde esten los equipos a realizar la busqueda.

    .EXAMPLE
        Get-UserLoggedOn -SamAccountName juan.parez,pablo.lopez
        pablo.lopez encontrado en equipo: PABLO-PC
        juan.parez encontrado en equipo: JUAN-PC

     .NOTES
        Requiere el modulo ActiveDirectory
#>

#Requires -Module ActiveDirectory
#Requires -RunAsAdministrator
#Requires -Version 3

[CmdletBinding()]
param ( 
    [parameter (Mandatory, 
        Position = 0,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [Alias('SamAccountName')]
    [String[]]
    $Identity,

    $SearchBase
)

process {
    $Domain = (Get-ADDomain).Name

    $Propertys = @{ Filter = 'enabled -eq "True"'  }

    IF ($PSBoundParameters.ContainsKey('SearchBase')) {
        $Propertys.SearchBase = $SearchBase  
    }

    Get-ADComputer @Propertys | ForEach-Object {

        $Computer = $_.Name

        try {
            $ComputerInformation = Get-CimInstance -Class Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop

            $Username = $ComputerInformation.Username
        
            foreach ($name in $Identity) {
                If ($Username -eq ("{0}\{1}" -f $Domain, $Name) ) {
                    Write-Output "$name encontrado en equipo: $Computer"
                    break 
                } # if
            } # foreach identity
        }
        catch {
            Write-Warning "Couldn't connect to $Computer" 
        }
    } # foreach
} # process
