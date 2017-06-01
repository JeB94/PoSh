function Get-Quini6 {
    [CmdletBinding()]
    param () 
   
    process {
        function Parsing {
            param (
                $InputObject ,

                [String[]]
                $Tipo
            )

            process {
                $Output = @{}
                foreach ($Type in $Tipo) {
                    Write-Verbose "Parsing $Type"
                    $Parse = $InputObject | Where-Object {$_.Innertext -match $Type} 
                
                    $Array = New-Object System.Collections.Generic.List[System.Object]
                    Foreach ($i in (0..5)) {
                        $Array.Add($Parse.Innertext.split("`n")[1].SubString($i * 2,2))
                    }

                    $Output.Add("$Type", $Array)

                } # foreach  
                $Object = New-Object PSObject -Property $Output
                Write-Verbose "Outputting results" 
                Write-Output $Object
 
            } # process
        } # function 

        try {
            $URL = "http://servicios.lanacion.com.ar/loterias/quini-6"
        
            $Query = Invoke-WebRequest -Uri $URL -ErrorAction Stop

            $Query_Object = $Query.ParsedHtml.getElementsByTagName('table')

            $Parameters = @{
                Tipo        = "Revancha", "Tradicional", "Segunda Vuelta", "Siempre Sale"
                InputObject = $Query_Object
            }

            Parsing @Parameters
  
        } catch [System.InvalidOperationException] {
            Write-Error "Couldn't resolve $URL"
        } catch {
            Write-Error "Error at parsing. Try again."
        } # end try catch
    } # process
} # function

