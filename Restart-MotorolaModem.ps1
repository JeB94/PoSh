Function Restart-MotorolaModem {
    [CmdletBinding()]
    
    param ()

    $Uri = "http://192.168.100.1"

    $Request = Invoke-WebRequest -Uri ("{0}/RgConfig.asp" -f $Uri)

    IF ($Request.StatusCode -ne 200) {
        throw "Can't connect to modem."
    }

    $Request.Forms.Fields.ResetReq = 1

    $Action = $Request.Forms.Action

    $Restart = Invoke-WebRequest -Uri ("{0}{1}" -f $Uri, $Action)  -Body $Request -Method Post
    
    IF ($Restart.StatusCode -ne 200) {
        throw "Couldn't restart modem"
    }

    Write-Verbose "Modem has been restarted"
}