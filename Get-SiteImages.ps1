<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER url

    .EXAMPLE

    .NOTES

#>

[CmdletBinding()]

param ( 

    [parameter(Mandatory)]
    [String]$url 
    
)


$path = "{0}\Desktop\Files-{1:dd-MM-yyyy}" -f $env:USERPROFILE , (Get-Date)

If (!( Test-Path $Path )) { 
    Write-Verbose -Message "Creating new folder"
    New-Item -Path $path -ItemType Directory | Out-Null
}


$invokeHtml = Invoke-WebRequest -Uri $url -UseBasicParsing

If ($invokeHtml.StatusCode -ne "200") {
    throw "Can't connect to $Url"
}

$imagenes = (($invokeHtml.Images).Where( {$_.src -match "[png|jpg]$"}).src).trimstart("//")
$count = $imagenes.count
$i = 0

IF ($Count -eq 0) {
    throw "Couldn't find images in the website"
}

$object = New-Object  System.Net.WebClient

Foreach ($Image in $Imagenes) {
    Write-Progress -Activity "Downloading Images:" -Status "Progress" -PercentComplete ($i / $count * 100)
    $FileName = [io.path]::GetFileName($Image)

    if (!($Image.StartsWith("http"))) { $Image = "http://{0}" -f $Image }
    
    try {
        $object.DownloadFile( $Image, ("{0}\{1}" -f $Path, $FileName ))
        $i ++
    }
    Catch {
        Write-Warning "Couldn't download $image"
    }
} 

Write-Output -InputObjec "$i images have been downloaded. Check $Path"

