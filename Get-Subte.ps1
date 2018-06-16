[CmdletBinding()]
param (

    [String]
    $Uri = "www.metrovias.com.ar"

) # param

begin {
    Write-Verbose "[BEGIN  ] Starting $($MyInvocation.MyCommand)"
    $GetDate = Get-Date

    $Time = "{0}:{1}" -f $GetDate.Hour, $GetDate.Minute

    $Date = "{0}/{1}/{2}" -f $GetDate.Day, $GetDate.Month, $GetDate.Year

} # begin

process {
    try {
        Write-verbose "[PROCESS] Parsing html"
        $GetSite = Invoke-WebRequest -Uri $Uri -ErrorAction Stop
    }
    catch {

        Write-Error 'Could not connect to site'

    } # try catch

    $array = New-Object System.Collections.Generic.List[System.Object]
    $Status = $GetSite.ParsedHtml.IHTMLDocument3_getElementsByTagName('table')[0].innertext -replace "L.nea|l.nea|L.NEA|Subte|Urquiza|Premetro", "" -split "`r"

    foreach ($s in $Status) {
        if ($s -match "\w+") {
            $Array.add($s)
        } # if
    } # foreach

    if ($array ) {
        $StatusSubte = [Ordered]@{
            'Time' = $Time
            'Date' = $Date
            'A'    = $array[1].Trim()
            'B'    = $array[3].trim()
            'C'    = $array[5].trim()
            'D'    = $array[7].trim()
            'E'    = $array[9].trim()
            'H'    = $array[11].trim()
            'P'    = $array[13].trim()
            'U'    = $array[15].trim()
        } # hashtable

        $Object = New-Object PSObject -Property $StatusSubte

        Write-Output $Object

    } # if

} # process

end {
    
    Write-Verbose "[END    ] Ending $($MyInvocation.MyCommand)"

}