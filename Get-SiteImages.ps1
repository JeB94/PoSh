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
    [String]$Url 
)

process {
    $Path = "{0}\Desktop\Files-{1:dd-MM-yyyy}" -f $env:USERPROFILE , (Get-Date)

    if (!( Test-Path $Path )) { 
        Write-Verbose -Message "Creating new folder"
        New-Item -Path $path -ItemType Directory | Out-Null
    }

    $invokeHtml = Invoke-WebRequest -Uri $url -UseBasicParsing

    If ($invokeHtml.StatusCode -ne "200") {
        throw "Can't connect to $Url"
    }

    $Imagenes = (($invokeHtml.Images).Where( {$_.src -match "[png|jpg]$"}).src).trimstart("//")

    IF ($Imagenes.Count -eq 0) {
        throw "Couldn't find images on the website"
    }

    $i = 0

    $Object = New-Object -TypeName System.Net.WebClient

    Foreach ($Image in $Imagenes) {
        Write-Progress -Activity "Downloading Images:" -Status "Progress" -PercentComplete ($i / $Imagenes.count * 100)
        $FileName = [IO.PATH]::GetFileName($Image)

        #Fix images urls
        if (!($Image.StartsWith("http"))) { $Image = "http://{0}" -f $Image }
    
        try {
            $object.DownloadFile( $Image, ("{0}\{1}" -f $Path, $FileName ))
            $i ++
        }
        Catch {
            Write-Warning "Couldn't download $image"
        }
    } 

    Write-Output "$i images have been downloaded. Check $Path"
}
