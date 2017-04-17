[CmdletBinding()]
param (
    [String]$Path,
    [Parameter(Mandatory)]
    [ValidateSet('es', 'en')]$Language
)

BEGIN { 
    function Get-Md5HashSnip {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [string] $Path
        )
        $file = Get-Item $Path -ErrorAction Stop
        if ($file -isnot [System.IO.FileInfo]) {
            throw "'$Path' does not refer to a file."
        }

        if ($file.Length -le 128kb) {
            $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        }
        else {
            #Crea objeto de 128kb
            $bytes = New-Object byte[](128kb)
            $stream = $file.OpenRead()

            #lee 64kb y lo ubica en posicion 0 de $bytes
            $null = $stream.Read($bytes, 0, 64kb)
            #Mueve puntero a ultimos 64kb de archivo
            $stream.Position = $stream.Length - 64kb
            #lee ultimos 64kb y ubica en 64kb restantes de bytes
            $null = $stream.Read($bytes, 64kb, 64kb)

            $stream.Close()
        }

        $md5 = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
        $hash = $md5.ComputeHash($bytes)

        [BitConverter]::ToString($hash) -replace '[^0-9a-f]'
    }
    IF ($Path -match "\[") { $path = $Path.Replace("[",'``[') }
    IF ($Path -match "\]") { $path = $Path.Replace("]",'``]') }

    $File = Get-Item -Path $Path

    $FileName = $File.Fullname
    $HashFile = Get-Md5HashSnip -Path  $path
    $output = @{}
}

PROCESS {
    $Url = "http://api.thesubdb.com/?action=download&hash={0}&language={1}" -f $HashFile, $Language
    
    $UserAgent = 'SubDB/1.0 (PoSh/1.0; http://github.com/jeb94/PoSh)'
    $output.File = $File.BaseName
    $output.Language = $Language

    try {

        $out = Invoke-RestMethod -UserAgent $UserAgent -Uri $url -ErrorAction SilentlyContinue
        $FilePath = Join-Path -Path $File.Directory -ChildPath "$($File.basename).srt"

        New-Item -Path $FilePath -Value $Out -ItemType File -Force | Out-Null

        $output.Message = "Subtitulo descargado"
        $output.Status = $True
    }

    catch {

        $output.Message = "No se encontro subtitulo"
        $output.Status = $False   

    }
}

END {

    $Object = New-Object PSObject -Property $output
    Write-Output -InputObject $Object
}


