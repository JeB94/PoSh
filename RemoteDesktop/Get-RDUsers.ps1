<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>
#Require -Verb RunAs

[CmdletBinding()]
param (
    [parameter(Position = 0)]
    [String[]]$ComputerName = "Localhost",

    [PSCredential]$Credential 

)

$Command = {
    $language = (Get-UICulture).name.substring(0, 2)

    #Posibilidad de  agregar mas idiomas
    $GroupsinLang = @{  
        es = "Usuarios de escritorio remoto"
        en = "Remote Desktop Users" 
    }

    $Group = $GroupsinLang[$Language]

    IF ($PSVersionTable.PSVersion.Major -ne '5') {

        $Wmi = Get-WmiObject -Class Win32_GroupUser | 
            Where-Object {  $_.groupcomponent -match $Group -and $_.groupcomponent -match $env:COMPUTERNAME }

        IF ($null -ne $wmi) {

            $Wmi | ForEach-Object {
                IF ($_.PartComponent -match "Group.Domain") { $Type = "Group" }

                else {  $Type = "User" }

                $parser = $_.partComponent.split(".")[1]

                $user = $Parser.split(",")[1].trimstart("Name=").trim('"')
                $Domain = $Parser.split(",")[0].trimstart("Domain=").trim('"')

                $Property = @{
                    Members = "{0}\{1}" -F $Domain, $User
                    Type = $Type
                }

                $Output = New-Object PSObject -Property $Property
                Write-Output $Output
            }
        }
        else {

            $Property = @{
                Members = $Null
                Type = $Null
            }

            $Output = New-Object PSObject -Property $Property
            Write-Output $Output

        }
    }
    else {
        Get-LocalGroupMember -Group $Group
    }
    
}

$Params = @{
    ComputerName = $ComputerName
    ScriptBlock = $Command
}

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) {
    $Params.remove("ComputerName") 
}

IF ($Credential) {
    $Params.credential = $Credential 
}

Invoke-Command @Params