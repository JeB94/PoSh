<#PSScriptInfo

.VERSION 0.1.2

.GUID 550cd282-235c-4d77-83ab-789eec91f5c5

.AUTHOR JeB94

.COMPANYNAME 

.COPYRIGHT 

.TAGS Subtitles movies series api subdb

.LICENSEURI 

.PROJECTURI https://github.com/JeB94/PoSh 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES

#>

<# 

.DESCRIPTION 
 Download subtitles from theSUBDB API. 

.EXAMPLE
Get-Subtitle.ps1 -Path 'D:\movies\inception.mp4' -Language es

.EXAMPLE
Get-ChildItem "D:\movies\*.mp4" | Select-Object -ExpandProperty FullName | Get-Subtitle.ps1 -Language es -DestinationPath D:\Subtitles

.EXAMPLE
Get-Subtitle.ps1  (Get-ChildItem -Filter *.mkv -Path 'D:\movies' | select-Object -ExpandProperty FullName) -Language it -Verbose
#> 

#Requires -Version 5

[CmdletBinding()]
param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [String[]]
    $Path,

    [String]
    $DestinationPath, 

    [ValidateSet('es', 'en',
        'fr', 'it',
        'nl', 'pl',
        'pt', 'ro',
        'sv', 'tr')]
    [String]
    $Language = 'en',

    [ValidateSet('srt', 'sub')]
    [String]
    $SubtitleExtension = 'srt'
)

begin { 
    function Get-SubDBFileHash {
        param (
            [ValidateNotNullOrEmpty()]
            [String]
            $Path)

        try {

            $file = Get-Item -LiteralPath $Path -ErrorAction Stop
            if ($file -isnot [System.IO.FileInfo]) {
                throw "$Path is not a file."
            }

            if ($file.Length -le 128KB) {
                $data = [System.IO.File]::ReadAllBytes($file.FullName)
            }
            else {
                $data = New-Object byte[](128KB)

                $stream = $file.OpenRead()

                $stream.Read($data , 0, 64KB) | Out-Null

                $stream.Position = $stream.Length - 64KB

                $stream.Read($data, 64KB, 64KB) | Out-Null

                $stream.Close()
            }
            Get-FileHash -InputStream ([IO.MemoryStream]$data) -Algorithm MD5 | Select-Object -ExpandProperty Hash
        }
        catch {
            Write-Error $_
        }
    } # Get-SubDBFileHash
    
    function Rename-FileItem {
        param (
            [String]
            $Path
        )
        ($Path -replace '`+\[', '[') -replace '`+\]', ']'
    }

    $ValidateExtensions = @(
        ".avi", ".mp4",
        ".mkv", ".mpg",
        ".mpeg", ".mov",
        ".rm", ".vob",
        ".wmv", ".flv", 
        ".flv", ".3gp",
        "3g2"
    )

} # begin

PROCESS {
    Foreach ($File in $Path ) {
        Write-Verbose "[PROCESS] Analyzing file $File"

        $File = Rename-FileItem $File

        # check file
        if (-not (Test-Path -LiteralPath $File)) { 
            Write-Error "File not found"
            Continue
        }
        # check extension
        elseif ([io.Path]::GetExtension($file) -notin $ValidateExtensions) {
            Write-Error "File extension is not valid"
            continue
        }

        $VideoFile = Get-Item -LiteralPath $File
        $VideoFilePath = Rename-FileItem $VideoFile.FullName

        Write-Verbose "[PROCESS] Calculating hash of $($VideoFile.BaseName)"
        $HashFile = Get-SubDBFileHash -Path $VideoFilePath
        Write-Verbose "[PROCESS] Hash was calculated correctly"


        $Url = "http://api.thesubdb.com/?action={0}&hash={1}&language={2}" -f "download" , $HashFile, $Language
        $UserAgent = 'SubDB/1.0 (Get-Subtitle/1.0; http://github.com/JeB94/Posh)'


        try {
            $QuerySubtitle = Invoke-RestMethod -UserAgent $UserAgent -Uri $url -ErrorAction Stop
            $VideoBaseName = '{0}.{1}' -f $VideoFile.BaseName, $SubtitleExtension

            $params = @{
                Value    = $QuerySubtitle
                ItemType = 'File'
                Force    = $True # ask then
            }

            if (!($PSBoundParameters.ContainsKey('DestinationPath'))) {
                $DestinationPath = $VideoFile.Directory
            }

            $params.Path = Join-Path -Path $DestinationPath -ChildPath  $VideoBaseName

            New-Item @Params | Out-Null
            Write-Verbose "[PROCESS] File saved on $DestinationPath"

            $Output = @{
                File     = $VideoFile.BaseName
                Language = $Language
            }

            [PSCustomObject]$output
        }
        catch {
            Write-Warning "$($language.ToUpper()) subtitle not found"
            Write-Warning "Searching for available subtitles"
            $Url = "http://api.thesubdb.com/?action={0}&hash={1}" -f "search" , $HashFile
            try {
                $SearchSubtitle = Invoke-RestMethod -UserAgent $userAgent -Uri $Url -ErrorAction Stop
                Write-Verbose "[PROCESS] Found available subtitle languages"
                $Output = @{
                    AvailableLanguages = $SearchSubtitle -split ","
                }

                [PSCustomObject]$Output
            }
            catch {
                Write-Warning "Not found any available subtitle for the file $($Videofile.BaseName)"
            }

        } # try catch
    } # process
} # functions 
