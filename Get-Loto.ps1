function Get-Loto {
    [CmdletBinding()]
    param ()

    process {
        try {
            $URL = "http://www.tujugada.com.ar/loto_new.asp"

            $Query = Invoke-WebRequest -Uri $URL

            $analize = $Query.Parsedhtml.GetElementsByTagName('table')
    
            $i = 0
            foreach ($t in $analize) {
                $i ++
                if ($t.innertext -match "^TRADICIONAL\s+$") {
                    Write-Verbose "Parsing TRADICIONAL set"
                    $tradicional = $analize[$i].innertext.Split("`n") 
                    $tradicional_jack = $analize[$i + 9].innertext.Split("`n") -match "^[\d\s]*$"
                }
                elseif ($t.innertext -match "^DESQUITE\s+$") {
                    Write-Verbose "Parsing DESQUITE set"
                    $desquite = $analize[$i].innertext.Split("`n") 
                    $desquite_jack = $analize[$i + 9].innertext.Split("`n") -match "^[\d\s]*$"
                }
                elseif ($t.innertext -match "^SALE O SALE\s*$") {
                    Write-Verbose "Parsing SALE O SALE set"
                    $sale_sale = $analize[$i].innertext.Split("`n") 
                }
            }
    
            $Regex = $analize[10].innertext | Select-String "(\d+)\W*([\d\/]*)(?:\s+)?$"
    
            $Property = [Ordered]@{
                Nro             = $Regex.Matches.Groups[1].Value
                Fecha           = $Regex.Matches.Groups[2].Value
                Tradicional     = $tradicional
                TradicionalJack = $tradicional_jack
                Desquite        = $desquite
                DesquiteJack    = $desquite_jack
                SaleOSale       = $sale_sale
            } 
    
            Write-Verbose "Outputting results of Loto $($Property.Nro)"
            $Object = New-Object PSObject -Property $Property
            Write-Output -InputObject $Object

        } catch [System.InvalidOperationException] {
            Write-Error "Couldn't resolve $URL"
        } # end try catch
    } # process
} # function



