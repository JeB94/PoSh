function Get-ValorMoneda {
    [CmdletBinding()]
    param (
        [Switch]
        $EURO, 

        $USD = "1",

        [Parameter(ValueFromPipeline)]
        [DateTime[]]
        $Date = (Get-Date)
    )

    begin {}

    process {
        Foreach ($Fecha in $Date) {

            #Format date
            $DateToUri = $Fecha.ToString("dd/M/yyyy")

            $Uri = "http://www.bna.com.ar/Cotizador/HistoricoPrincipales?id=billetes&fecha={0}&filtroEuro={1}&filtroDolar={2}" -f $DateToUri, [int]!!($Euro), $Usd
            $WebRequest = Invoke-WebRequest -Uri $Uri 

            if (!($WebRequest)) {
                throw "Couldn't make a request to $Uri"
            } # if
       
            $array = $WebRequest.AllElements.Where( {$_.TagName -eq "td"}).InnerText
            $Dic = @{}
            $i = 0

            for ($e = 0; $e -lt ($Array.count / 4) ; $e ++) {
                $Dic.Moneda = $array[$i ++]
                $Dic.Compra = $Array[($i ++)]
                $Dic.Venta = $Array[($i ++)]
                $Dic.Fecha = $Array[($i ++)]

                # output object with the input date
                if ($dic.fecha -eq $DateToUri) {
                    [PSCustomObject]$Dic
                } # if
            } # for
        } # foreach
    } # process

    end {}

} # function