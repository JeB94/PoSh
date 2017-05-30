<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>
[CmdletBinding()]
param (
    [parameter (Mandatory)]
    [String]$Legajo,
    [PSCredential]$Password
)

BEGIN {

    $dic = @{
        uno = 1; dos = 2;
        tres = 3; cuatro = 4;
        cinco = 5; seis = 6;
        siete = 7; ocho = 8;
        nueve = 9; diez = 10
    }
        
    $url = "https://autogestion.frd.utn.edu.ar/"

    IF (!($PSBoundParameters.ContainsKey("credential"))) {
        $credential = Get-Credential -UserName $Legajo -Message "Ingresar clave de SYSACAD"
    }
}

PROCESS {

    try {
        
        # Login to site

        $Invoke = Invoke-webrequest -Uri $url -SessionVariable Sesion -ErrorAction Stop 
        $Invoke.Forms.Fields['legajo'] = $Legajo
        $Invoke.Forms.Fields['password'] = $credential.GetNetworkCredential().Password

        $Action = $Invoke.Forms.Action
        $Login = Invoke-WebRequest -uri ( "{0}{1}" -f $url, $action ) -WebSession $Sesion -Body $Invoke -Method Post -ErrorAction Stop

        # Querys 
        $Examenes = Invoke-WebRequest -uri ("{0}/examenes.asp" -f $Url) -WebSession $Sesion

        $cursado = Invoke-WebRequest -Uri "$url/notasParciales.asp" -WebSession $Sesion

        $correlatividad = Invoke-WebRequest -uri "$url/correlatividadExamen.asp" -WebSession $Sesion

        $notas = $($Examenes.AllElements | Where-Object tagname -eq 'td'  | Select-Object -ExpandProperty outertext )

        $cursado_Parse = $($cursado.Allelements | Where-Object tagname -eq 'td' | Select-Object -ExpandProperty outertext )
        
        $i = 0
        $arrayMaterias = @()
        $notas | ForEach-Object {
            $i ++
            $Valores = $_
            IF ($Valores -in $dic.Keys) {
                $finalesRendidos = @{
                    Fecha = $notas[$i - 3]
                    Materia = $notas[$i - 2]
                    Nota = $dic.$valores
                }
                $ObjetoMaterias = New-Object psobject -Property $finalesRendidos
                $arrayMaterias += $ObjetoMaterias
                $contador += 1
                $acumulador += $dic.$Valores
            }
            
        }

        $promedio = $acumulador / $contador
   
        $finales = $correlatividad.AllElements | Where-Object {$_.tagname -eq 'td'} | Select-Object -ExpandProperty innertext
        $i = 0
        $final = @()
        $finales | ForEach-Object {
            $i ++
            if ($_ -eq "Puede inscribirse" ) {
                $anterior = $i - 2
                $final += $finales[$anterior]
            }
            
        }

        Write-Output -InputObject $arrayMaterias
        Write-Output -InputObject "PROMEDIO: $promedio"
        Write-Output -InputObject ""
        Write-Output -InputObject "Materias para rendir final:"
        Write-Output -InputObject $final
    
    } #Cierre try
    catch {
        Write-Warning -Message "El sitio no esta disponible"
    }

}



