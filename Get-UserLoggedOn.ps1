<#
    .SYNOPSIS
        Script que devuelve en que equipo se encuentra un usuario
    
    .DESCRIPTION
        Este Script busca en qué equipo esta logeado determinado usuario. Se pueden buscar mas de un usuario.
        Para el parametro User, se debe utilizar si o si el SamAccountName del usuario. Este se puede encontrar haciendo una busqueda del usuario en el AD.
        El SamAccountName es el string que se utiliza para iniciar sesión en windows.

    .PARAMETER Identity
        Especifica nombre de usuario. Se utiliza el SamAccountName. Acepta mas de un usuario.

    .PARAMETER SearchBase
        Especifica OU donde esten los equipos a realizar la busqueda. Por defecto esta configurado para que sea la OU Computers en la OU Zarcam

    .EXAMPLE
        Get-UserLoggedOn -SamAccountName juan.parez,pablo.lopez
        pablo.lopez encontrado en equipo: PABLO-PC
        juan.parez encontrado en equipo: JUAN-PC
    
    .EXAMPLE 
        Get-ADUser -Identity juan.parez | Get-UserLoggedOn.ps1
        juan.parez encontrado en equipo: JUAN-PC
    
     .EXAMPLE
        Get-ADUser -Filter * -searchbase "ou=computers,ou=contoso,dc=contoso,dc=local" | Get-UserLoggedOn.ps1
        juan.parez encontrado en equipo: JUAN-PC
        pablo.lopez encontrado en equipo: PABLO-PC
        damian.lara encontrado en equipo: DAMIAN

        Si se utiliza el comando por pipeline, no hace falta hacer un SELECT del SamAccountName. Automaticamente lo toma.

    .EXAMPLE
        Get-UserLoggedOn -SamAccountName (Get-ADUser -filter * -searchbase "ou=computers,ou=contoso,dc=contoso,dc=local" ).samaccountname

        Este ejemplo lo que hace es traer todos los usuarios dentro de la OU Administracion. Luego busca en que equipos estan logeados los mismos, si es que lo estan.
        En este caso, si se debe especificar que tome el SamAccountName de los usuarios, ya que no se utiliza el comando por pipeline.

     .NOTES
        Requiere el modulo ActiveDirectory

        

#>

[CmdletBinding()]
param ( 
        [parameter (Mandatory = $True, 
                    Position = 0,
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('SamAccountName')]
        [String[]]$Identity,
        $SearchBase
    )

$Domain = (Get-ADDomain).Name
#Probar esto ... el filtro y el searchbase (en caso de que no se ingrese)
#Probar sin select y con $computer = $_.name (measure-command)
$Propertys = @{ Filter = 'enabled -eq "True"'  }
IF ($SearchBase) { $Propertys.SearchBase = $SearchBase  }

Get-ADComputer @Propertys | ForEach-Object {
    $Computer = $_.Name
    try 
    {
        $ComputerInformation = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop
        $Username = $ComputerInformation.Username
        foreach ($name in $Identity)
        {
            If ($Username -eq "$Domain\$name") 
            {
                Write-Output "$name encontrado en equipo: $Computer"
                break 
            } 
        } # Close Foreach Users
    }   #Close Try instance
    catch [System.UnauthorizedAccessException]
    {
         Write-Error "Requiere permisos administrador"
         break
    }
} #Close ForEach Computers
