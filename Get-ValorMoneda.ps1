[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline)]
    [ValidatePattern("\d{0,2}\/\d{0,2}\/\d{4}")]  # date pattern
    $Date = (Get-Date)
)

process {
    Foreach ($Fecha in $Date) {
        Write-Verbose "Querying values for date $Fecha"

        #Format date
        $DateToUri = (Get-Date -Date $fecha).ToString("d/M/yyyy")

        $Uri = "http://www.bna.com.ar/Cotizador/HistoricoPrincipales?id=billetes&fecha={0}&filtroEuro=1&filtroDolar=1" -f $DateToUri
        $WebRequest = Invoke-WebRequest -Uri $Uri 

        if (!($WebRequest)) {
            throw "Couldn't make a request to $Uri"
        } # if
        
        Write-Verbose "Parsing website"
        $array = $WebRequest.AllElements.Where( {$_.TagName -eq "td"}).InnerText
        $Dic = @{}
        $i = 0
        $Warning = $true

        for ($e = 0; $e -lt ($Array.count / 4) ; $e ++) {
            $Dic.Moneda = $array[$i ++]
            $Dic.Compra = $Array[($i ++)]
            $Dic.Venta = $Array[($i ++)]
            $Dic.Fecha = $Array[($i ++)]

            # output object with the input date
            Write-Verbose "Checking date $($Dic.Fecha)"
            if ($Dic.Fecha -eq $DateToUri) {
                $Warning = $False
                Write-Verbose "Outputting values from $Fecha"
                [PSCustomObject]$Dic
            }
        } # for
        
        if ($Warning) {
            Write-Warning "Not values found for date $fecha"
        }
 
    } # foreach
} # process

