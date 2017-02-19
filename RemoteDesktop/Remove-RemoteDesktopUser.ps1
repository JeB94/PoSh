[CmdletBinding()]
param (
    [parameter(Position = 0)]
    [String[]]$ComputerName = "Localhost",
    [Alias("Username","Identity")]
    [String[]][Parameter(Mandatory)] $Member,
    $Credential 

) 

$Command = { 
    $language =  (Get-UICulture).name.substring(0,2)

    #Posibilidad de  agregar mas idiomas
    $GroupsinLang = @{  es = "Usuarios de escritorio remoto"
                        en =  "Remote Desktop Users" 
            }

    $Group  = $GroupsinLang[$Language]
    $i = 0
    Foreach ($user in $Member) {
        Write-Output "[$i] Deshabilitando a: $User"
        net LocalGroup $Group /DELETE $user
        Write-Output ""
        $i += 1
    }

}

$Params = @{
    ComputerName = $ComputerName
    ScriptBlock  = $Command
}

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) {
    $Params.remove("ComputerName") 
}

IF ($Credential -ne $null) {
    $Params.credential = $Credential 
}
Invoke-Command @Params