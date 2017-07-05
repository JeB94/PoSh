[CmdletBinding()]
param (
    [Parameter( ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [Alias("Server", "CN")]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $ComputerName = $ENV:COMPUTERNAME
)

process {
    foreach ($computer in $ComputerName) {
        Write-Verbose "Querying $Computer"
        try {
            $info = Get-CimInstance win32_operatingsystem -ComputerName $Computer  -ErrorAction Stop  |
                Select-Object  @{n = "version"; e = {($_.version -replace "\d+\.\d\.(\d{5})", '$1')}}, caption, OsArchitecture

            Write-Verbose "Connected to $Computer"  

            $property = @{
                ComputerName    = $computer
                OperatingSystem = $info.Caption
                Arquitectura    = $Info.OsArchitecture  
                Build           = $Info.Version
            } # hashtable
        
            if ($info.Caption -like "*windows 10*") {
                switch ($info.version) {
                    '14393' {$property.Version = "1607" } 
                    '10586' {$property.version = "1511"} 
                    '15063' {$Property.version = "1703"} 
                    default {$property.version = "Standard" }
                } # switch
            }
            else {
                $property.Version = $Null
            }

            Write-Verbose "Outputting $Computer"
            [Pscustomobject]$property
        }
        catch {
            Write-Error $_
        } # try catch 
    } # foreach
} # process

