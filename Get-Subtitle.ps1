<#PSScriptInfo

.VERSION 0.2.4

.GUID 550cd282-235c-4d77-83ab-789eec91f5c5

.AUTHOR JeB94

.COMPANYNAME 

.COPYRIGHT 

.TAGS subtitle movies series api subdb srt sub subtitles tv

.LICENSEURI https://github.com/JeB94/PoSh/blob/master/LICENSE

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
Get-Subtitle.ps1 -InstallShortCut

.EXAMPLE
Get-Subtittle.ps1 -UninstallShortCut

.EXAMPLE
Get-Subtitle.ps1 -Path 'D:\movies\movie.mp4' -Language es

.EXAMPLE
Get-ChildItem "D:\movies\*.mp4" | Select-Object -ExpandProperty FullName | Get-Subtitle.ps1 -Language es -DestinationPath D:\Subtitles

.EXAMPLE
Get-Subtitle.ps1  (Get-ChildItem -Filter *.mkv -Path 'D:\movies' | select-Object -ExpandProperty FullName) -Language it -Verbose
#> 

#Requires -Version 5

[CmdletBinding(DefaultParameterSetName = 'Download',
    SupportsShouldProcess = $True,
    ConfirmImpact = 'High')]

param (
    [Parameter(Mandatory, 
        ValueFromPipeline,
        Position = '0', ParameterSetName = 'Download')]
    [String[]]
    $Path,

    [Parameter(ParameterSetName = 'Download')]
    [String]
    $DestinationPath, 

    [Parameter(ParameterSetName = 'Download', Position = '1')]
    [ValidateSet('es', 'en',
        'fr', 'it',
        'nl', 'pl',
        'pt', 'ro',
        'sv', 'tr') ]
    [String]
    $Language = 'en',

    [Switch]
    $Force,

    [Parameter(ParameterSetName = 'Download')]
    [ValidateSet('srt', 'sub')]
    [String]
    $SubtitleExtension = 'srt',

    [Parameter(ParameterSetName = 'Install')]
    [Switch]
    $InstallShortCut, 

    [Parameter(ParameterSetName = 'Uninstall')]
    [Switch]
    $UninstallShortCut

)

begin { 
    Write-Verbose "[BEGIN  ] Starting $($MYINVOCATION.MyCommand)"

    # Install BurntToast for notifications 
    $requiredModule = 'BurntToast'
    if ($requiredModule -notin (Get-Module -ListAvailable -Verbose:$False).Name) {
        Write-Verbose -Message "[BEGIN  ] BurntToast module not found "
        try {

            Write-Verbose -Message "[BEGIN  ] Installing BurntToast module" -Verbose
            Install-Module 'BurntToast' -Force
        }
        catch {
            Write-Warning 'Could not install BurntToast Module'
        }
    }

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

    $RegistryPath = 'Registry::HKEY_CLASSES_ROOT\``*\Shell'
    $SubtitlePath = Join-Path $RegistryPath 'Subtitle'
} # begin

PROCESS {

    if ($PsCmdlet.ParameterSetName -eq 'install') {

        if ($PsCmdlet.ShouldProcess("Registry::HKEY_CLASSES_ROOT", "InstallShortCut")) {

            Write-Verbose '[PROCESS] Creating registry values'

            if (!(Test-Path $SubtitlePath) -or $Force) {

                try {
                    $Param = @{
                        ErrorAction = 'Stop'
                    }

                    if ($Force) {
                        $Param.Add("Force", $True)
                    } 

                    Write-Verbose "[PROCESS] Creating Subtitle value"
                    New-Item -Path $RegistryPath -Name 'Subtitle' -ItemType Directory @Param | Out-Null
                    New-ItemProperty -Path $SubtitlePath -Name 'SubCommands' @Param | Out-Null

                    # create child folder
                    New-Item -Path $SubtitlePath -Name 'shell' @Param | Out-null
                    $shellPath = Join-Path $SubtitlePath 'shell'

                    # create folder for each language
                    # spanish
                    Write-Verbose "[PROCESS] Adding Spanish option"
                    $LanguagePath = Join-Path $shellPath "Spanish"
                    New-Item -Path $shellPath -Name "Spanish" -Value "Spanish" @Param | Out-Null
                    New-Item -Path $LanguagePath -Name Command @Param -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy ByPass -noprofile -command Get-Subtitle.ps1 '`"%1`"' es -Force"  | Out-Null
                    Write-Verbose "[PROCESS] Added spanish language"

                    # english
                    Write-Verbose "[PROCESS] Adding English option"
                    $LanguagePath = Join-Path $shellPath "English"
                    New-Item -Path $shellPath -Name "English" -Value "English" @Param | Out-Null
                    New-Item -Path $LanguagePath -Name Command @Param -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy ByPass -noprofile -command Get-Subtitle.ps1 '`"%1`"' en -Force"  | Out-Null
                    Write-Verbose "[PROCESS] Added English language"
                }
                catch {
                    Write-Error $_
                } # try catch
            }
            else {
                Write-Warning "[PROCESS] Shorcut is already configured"
            }
        } # if
    }
    
    # Uninstall ParameterSet
    elseif ($PsCmdlet.ParameterSetName -eq 'uninstall' ) {
        Write-Verbose "[PROCESS] Removing registry values"

        if ($PsCmdlet.ShouldProcess("Registry::HKEY_CLASSES_ROOT", "UninstallShortCut")) {
            if (Test-Path $SubtitlePath) {

                try {
                    Write-Verbose "[PROCESS] Removing values"
                    Remove-Item -Path $SubtitlePath -Recurse -ErrorAction Stop | Out-Null  
                    Write-Verbose "[PROCESS] Shortcut was uninstalled"
                }
                catch {
                    Write-Error "Denied Access. Run cmdlet as Administrator"
                }
            }
            else {
                Write-Warning "[PROCESS] Shorcut have already been uninstalled"
            }

        } # if should process

    }

    # Download ParameterSet
    else {
        Foreach ($File in $Path ) {
            Write-Verbose "[PROCESS] Analyzing file $File"

            # avoid problems with wildcards
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

            # api info
            $Url = "http://api.thesubdb.com/?action={0}&hash={1}&language={2}" -f "download" , $HashFile, $Language
            $UserAgent = 'SubDB/1.0 (Get-Subtitle/1.0; http://github.com/JeB94/Posh)'


            try {
                # query api
                $QuerySubtitle = Invoke-RestMethod -UserAgent $UserAgent -Uri $url -ErrorAction Stop
                $VideoBaseName = '{0}.{1}' -f $VideoFile.BaseName, $SubtitleExtension
                
                $params = @{
                    Encoding = 'default'
                }

                #  supports force
                if ($Force) {
                    $params.Force = $True
                }

                # adding destination path
                if (!($PSBoundParameters.ContainsKey('DestinationPath'))) {
                    $DestinationPath = $VideoFile.Directory
                }

                $params.LiteralPath = Join-Path -Path $DestinationPath -ChildPath  $VideoBaseName

                # saving file
                try {
                    $QuerySubtitle | Out-File @Params 
                    Write-Verbose "[PROCESS] File saved on $DestinationPath"

                    # send desktop notificacion
                    try {
                        New-BTAppId -WarningAction SilentlyContinue
                        New-BurntToastNotification -Text "Subtitle Downloaded!", "$VideoBaseName" -Silent
                    } 
                    catch {
                        # BurntToast module is not installed
                        Out-Null
                    }

                    $Output = @{
                        File     = $VideoFile.BaseName
                        Language = $Language
                    }

                    [PSCustomObject]$output
                }
                catch {
                    Write-Error $_
                }
            }
            catch {
                # search for available languages
                Write-Warning "$($language.ToUpper()) subtitle not found"
                Write-Warning "Searching for available subtitles"
                $Url = "http://api.thesubdb.com/?action={0}&hash={1}" -f "search" , $HashFile

                # query api for available languages
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
        } # foreach
    } # parameter set download
} # process

end {
    Write-Verbose "[END    ] Ending $($MyInvocation.MyCommand)"
}
