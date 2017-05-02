function Get-Loto {
    [CmdletBinding()]
    param ()

    $Url = "http://www.tujugada.com.ar/loto_new.asp"
    $analize = (Invoke-WebRequest $url).Parsedhtml.GetElementsByTagName('table')
    
    $i = 0
    foreach ($t in $analize) {
        $i ++
        if ($t.innertext -match "^TRADICIONAL\s+$") {
            Write-Verbose "Parsing for TRADICIONAL"
            $tradicional = $analize[$i].innertext.Split("`n") 
            $tradicional_jack = $analize[$i + 9].innertext.Split("`n") -match "^[\d\s]*$"
        }
        elseif ($t.innertext -match "^DESQUITE\s+$") {
            Write-Verbose "Parsing for DESQUITE"
            $desquite = $analize[$i].innertext.Split("`n") 
            $desquite_jack = $analize[$i + 9].innertext.Split("`n") -match "^[\d\s]*$"
        }
        elseif ($t.innertext -match "^SALE O SALE\s*$") {
            Write-Verbose "Parsing for SALE O SALE"
            $sale_sale = $analize[$i].innertext.Split("`n") 
        }
    }
    
    $Regex = $analize[10].innertext | Select-String "(\d+)\W*([\d\/]*)(?:\s+)?$"
    
    $Property = [Ordered]@{
        Nro = $Regex.Matches.Groups[1].Value
        Fecha = $Regex.Matches.Groups[2].Value
        Tradicional = $tradicional
        TradicionalJack = $tradicional_jack
        Desquite = $desquite
        DesquiteJack = $desquite_jack
        SaleOSale = $sale_sale
    } 
    
    Write-Verbose "Outputting results of Loto $($Property.Nro)"
    $Object = New-Object PSObject -Property $Property
    Write-Output -InputObject $Object
}

