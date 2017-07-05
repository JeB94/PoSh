function Set-Muilanguages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ComputerName,

        [ValidateSet("es-ES", "es-MX", "en-US")]
        $RemoveLanguage
    )

    $ComputerInfo = .\Get-Win10Version.ps1 -ComputerName $ComputerName

    $versiones = @{
        "10586" = "\\esteban\software\Microsoft\mui languages\1511\es-ES\lp_47afd6de9c3f3f5e56eb65a4232ebb76b9d77c60.cab"
        "14393" = "\\esteban\software\microsoft\mui languages\1603\es-es\lp_9d70f4d51680deaaf951eccb6c2216fc3b9ef368.cab"
    }

    try {
        Write-Verbose "Copiando archivo cab"
        Copy-Item -Path $versiones[$ComputerInfo.Build] -Destination (Join-Path -Path "\\$ComputerName" -ChildPath "C$")
    } catch {
        Write-Error "No se pudo copiar el archivo $($Versiones[$ComputerInfo.Build])"
        break
    }
    $PackageName = [System.IO.Path]::GetFileName($versiones[$ComputerInfo.Build])

    $PackagePath = Join-Path -Path "C:" -ChildPath $PackageName
    $command = {
        try {
            Add-WindowsPackage -PackagePath $using:Packagepath  -Online
        } catch {
            Write-Error "no se pudo instalar archivo"
            break
        }
        $package = Get-WindowsPackage -Online | Where-Object packagename -like "*client-languagepack*$($using:RemoveLanguage)*" 

        if ($Null -ne $package) {
            Write-Verbose "Removing windows package"
            Remove-WindowsPackage -NoRestart -PackageName $package.Packagename -Online

            Restart-Computer -Wait -For PowerShell -Force -Verbose -Timeout 180 -Delay 2
            Get-WindowsPackage -Online  | Where-Object packagename -like "*client-languagepack*" 

        }
    }

    Invoke-Command -ComputerName $ComputerName -Command $command
}

