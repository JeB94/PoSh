<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>
[CmdletBinding()]
param (
    [parameter(Position = 0)]
    [String[]]$ComputerName = "Localhost",
    [Alias("Username", "Identity")]
    [String[]][Parameter(Mandatory)] $Member,
    [PSCredential]$Credential 

) 

$Command = { 
    $language = (Get-UICulture).name.substring(0, 2)

    #Posibilidad de  agregar mas idiomas
    $GroupsinLang = @{  es = "Usuarios de escritorio remoto"
        en = "Remote Desktop Users" 
    }

    $Group = $GroupsinLang[$Language]
    $i = 0
    Foreach ($user in $using:Member) {
        Write-Output "[$i] Habilitando a $User"
        net LocalGroup $Group /ADD $user
        $i += 1
    }

}

$Params = @{
    ComputerName = $ComputerName
    ScriptBlock = $Command
}

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) {
    $Params.remove("ComputerName") 
}

IF ($null -eq $Credential) {
    $Params.credential = $Credential 
}
Invoke-Command @Params