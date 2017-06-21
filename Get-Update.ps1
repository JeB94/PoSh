Function Get-Update {
    #Requires -RunAs
    [CmdletBinding()]
    param ()

    $Criteria = "IsInstalled=0 and Type='Software'"

    $Searcher = New-Object -ComObject Microsoft.Update.Searcher
    try {
        Write-Verbose "Searching for updates"
        $SearchResult = $Searcher.Search($Criteria).Updates
        if ($SearchResult.Count -eq 0) {
            Write-Warning "There are no applicable updates."
            break
        } 
        else {
            Write-Verbose "There are $($SearchResult.count) updates"
            $Session = New-Object -ComObject Microsoft.Update.Session
            $Downloader = $Session.CreateUpdateDownloader()

            Foreach ($Result in $SearchResult) {
                $Title = $Result.Title
                Write-Verbose "Assigning $Title to download"
                try {
                    if ($Result.InstallationBehavior.CanRequestUserInput ) {
                        Write-Warning "Couldn't download $Title. It needs user input"
                        continue
                    }
                    else {
                        if (!($Result.EulaAccepted)) {
                            Write-Verbose "Accepting EULA for $Title"
                            $Result.AcceptEula()
                        } # if eula
                    } # if else

                    $UpdateCol = New-Object -Com "Microsoft.Update.UpdateColl"
                    $UpdateCol.Add($Result) | Out-Null
                    $Downloader.Updates = $UpdateCol

                    Write-Verbose "Downloading $Title"
                    $Downloader.Download()
                    $Installer = New-Object -ComObject Microsoft.Update.Installer
            
                    Write-Verbose "Installing update $Title"
                    $Installer.Updates = $Result
                    $Result = $Installer.Install() | Out-Null

                    Write-Verbose "$Title was installed"
                    
                    if ($Result.RebootRequired) {
                        Write-Warning "Reboot required. Please restart computer"
                    } 
                } catch {
                    $Error[0].Message
                } # try catch download
            } # foreach
            
        } # if else
    } catch {
        Write-Warning "Couldn't search for updates"
    } # try catch
} # function
