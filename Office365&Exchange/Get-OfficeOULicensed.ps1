<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES
    
#>
$users = (Get-MsolUser).Where( {$_.IsLicensed}) | Select-Object displayname, department

IF (!($Users)) {
    throw  "User hasn't logged in to Office365. Use the function 'Connect-Office365'"
} 

$departments = $users.Department | Select-Object -Unique

foreach ($department in $departments) {
    $i = 0
    Foreach ($User in $Users) {
        if ($User.department -eq $Department ) {
            $i ++
        }
    }

    $Property = @{
        "Departamento" = $Department
        "Licencias" = $i
    }

    $Objeto = New-Object PSObject -Property $Property   

    Write-Output -InputObject $Objeto
}
