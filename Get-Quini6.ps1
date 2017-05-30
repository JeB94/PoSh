function Get-Quini6 {
    [CmdletBinding()]
    param () 

    $url = "http://servicios.lanacion.com.ar/loterias/quini-6"
    
    $analize = (Invoke-WebRequest $url).AllElements | 
        Where-Object tagname -eq 'b' | 
        Select-Object -expand outertext     | 
        Where-Object {$_ -match '^\d+$'}

    $tradicional = $analize[0 .. 5]
    $siempre_sale = $analize[24 .. 29]
    $segunda_vuelta = $analize[6 .. 11]
    $revancha = $analize[12 .. 17]

    $Property = [Ordered]@{ 
        "Tradicional" = $tradicional
        "Siempre sale" = $siempre_sale
        "Segunda vuelta" = $segunda_vuelta
        "Revancha" = $analize[12 .. 17] 
    }
    
    Write-Verbose "Outputting results of quini6"
    $Object = New-Object PSObject -Property $Property
    Write-Output -InputObject $Object
}
