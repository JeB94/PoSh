[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String[]]
    $Uri,

    $Path = "$($ENV:USERPROFILE)\Desktop"
)

process {
    $ApiUrl = "http://www.youtubeinmp3.com/fetch/?format=JSON&video="

    if (!(Test-Path $path)) {
        throw "Path doesn't exist"
    }

    Foreach ($url in $uri) {
        $Query = Invoke-RestMethod -uri ("{0}{1}" -f $ApiUrl, $Url )

        if (!($Query.link)) {
            Write-Error "File not found"
        }

        $DownloaderObject = New-Object Net.WebClient 

        #Delete characters that aren't allow for filenames
        $FileName = "{0}.mp3" -f ($Query.title -replace '[\/:?"|\\><]',"" )
        $FilePath = Join-Path -Path $Path -ChildPath $FileName

        try {
            $DownloaderObject.DownloadFile($Query.Link, $FilePath)
            Write-Verbose -Message "File $FileName downloaded"
        }
        catch {
            Write-Error "Couldn't download $FileName"
        }
    }
}

