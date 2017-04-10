<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER url

    .EXAMPLE

    .NOTES
    Requiere los modulos ActiveDirectory 
    BEGIN { }

PROCESS { }

END { }
#>

[CmdletBinding()]

param ( 

    [parameter(Mandatory)]
    [String]$url 
    
    )


$path = "{0}\Desktop\Files-{1:dd-MM-yyyy}" -f $env:USERPROFILE , (Get-Date)

If (!( Test-Path $Path )) { 

    Write-Verbose -Message "Creating new folder"
    New-Item -Path $path -ItemType Directory

}



$invokeHtml = Invoke-WebRequest -Uri $url -UseBasicParsing

If ($invokeHtml.StatusCode -eq "200") {
    $imagenes = $invokeHtml.Images | Select-Object -ExpandProperty Src -ErrorAction SilentlyContinue
    $object = New-Object  System.Net.WebClient
    $array = @()
    $imagenes | ForEach-Object {
        try {
            $invoke = Invoke-WebRequest -Uri $_ -ErrorAction Stop
            if ($Invoke.StatusCode -eq '200') { $array += $_ }  
        }
       catch { Out-Null }
     }
    $count = $array.count
    $array | ForEach-Object {
        try {
                $i ++
                Write-Progress -Activity "Downloading Images:" -Status "Progress" -PercentComplete ($i/$count*100)
                $uri = [io.path]::GetFileName($_)
                $object.DownloadFile( $_, ("$path\" + $uri ) )
        } 
        catch { Out-Null }
        }
     Write-Output -InputObject "Se descargaron $i imagenes en $path."
     Start-sleep -Seconds 5
}
Else { 
    Write-Warning -Message "Sitio no encontrado."
    Start-sleep -Seconds 3 }