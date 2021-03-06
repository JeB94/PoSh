function New-Report {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        $Data,

        [String]
        [Alias('ComputerName')]
        $Target

    )

            
    $fullReport = "<img src=data:image/jpeg;base64,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 alt='ALGEIBA'></font></b><color='#EB9C12'>"
    $Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html ES_auditInitialized='false'><head><title>Guia de Operaciones: $target</title>
<META http-equiv=Content-Type content='text/html; charset=windows-1252'>
<STYLE type=text/css>	
DIV .expando {DISPLAY: block; FONT-WEIGHT: normal; FONT-SIZE: 8pt; RIGHT: 10px; COLOR: #ffffff; FONT-FAMILY: Tahoma; POSITION: absolute; TEXT-DECORATION: underline}
TABLE {TABLE-LAYOUT: fixed; FONT-SIZE: 100%; WIDTH: 100%}
#objshowhide {PADDING-RIGHT: 10px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; Z-INDEX: 2; CURSOR: hand; COLOR: #000000; MARGIN-RIGHT: 0px; FONT-FAMILY: Tahoma; TEXT-ALIGN: right; TEXT-DECORATION: underline; WORD-WRAP: normal}
.heading0_expanded {BORDER-RIGHT: #bbbbbb 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 8px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 0px; BORDER-LEFT: #bbbbbb 1px solid; WIDTH: 100%; CURSOR: hand; COLOR: #FFFFFF; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; BACKGROUND-COLOR: #cc0000}
.heading1 {BORDER-RIGHT: #bbbbbb 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 16px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 5px; BORDER-LEFT: #bbbbbb 1px solid; WIDTH: 100%; CURSOR: hand; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; BACKGROUND-COLOR: #7BA7C7}
.heading2 {BORDER-RIGHT: #bbbbbb 1px solid; PADDING-RIGHT: 5em; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 16px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: -1px; MARGIN-LEFT: 5px; BORDER-LEFT: #bbbbbb 1px solid; WIDTH: 100%; CURSOR: hand; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; HEIGHT: 2.25em; BACKGROUND-COLOR: #A5A5A5}
.tableDetail {BORDER-RIGHT: #bbbbbb 1px solid; BORDER-TOP: #bbbbbb 1px solid; DISPLAY: block; PADDING-LEFT: 16px; FONT-SIZE: 8pt;MARGIN-BOTTOM: -1px; PADDING-BOTTOM: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #bbbbbb 1px solid; WIDTH: 100%; COLOR: #000000; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: #bbbbbb 1px solid; FONT-FAMILY: Tahoma; POSITION: relative; BACKGROUND-COLOR: #f9f9f9}
.filler {BORDER-RIGHT: medium none; BORDER-TOP: medium none; DISPLAY: block; BACKGROUND: none transparent scroll repeat 0% 0%; MARGIN-BOTTOM: -1px; FONT: 100%/8px Tahoma; MARGIN-LEFT: 43px; BORDER-LEFT: medium none; COLOR: #ffffff; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: medium none; POSITION: relative}
.Solidfiller {BORDER-RIGHT: medium none; BORDER-TOP: medium none; DISPLAY: block; BACKGROUND: none transparent scroll repeat 0% 0%; MARGIN-BOTTOM: -1px; FONT: 100%/8px Tahoma; MARGIN-LEFT: 0px; BORDER-LEFT: medium none; COLOR: #000000; MARGIN-RIGHT: 0px; PADDING-TOP: 4px; BORDER-BOTTOM: medium none; POSITION: relative; BACKGROUND-COLOR: #000000}
td {VERTICAL-ALIGN: TOP; FONT-FAMILY: Tahoma}
th {VERTICAL-ALIGN: TOP; COLOR: #cc0000; TEXT-ALIGN: left}
</STYLE>
</HEAD>
<BODY>
$fullReport
<b><font face="Arial" size="5">$($Header)</font></b><hr size="7" color="#EB9C12">
<font face="Arial" size="3"><b>Guia de Operaciones Version 2.0 | Algeiba IT |</b> <A HREF='http://www.algeiba.com/'>http://www.algeiba.com/</A></font><br>
<font face="Arial" size="2">Reporte creado el dia $(Get-Date)</font>
</br>
</br>
<font face="Arial" size="2">En el presente documento se desarrollan los items relevados que forman parte de la Guia de Operaciones de Algeiba SA. Esta guia de operaciones tiene como objetivo</font>
<font face="Arial" size="2">generar todas las actividades pro-activas necesarias para velar por las plataformas intervinientes.</font></br>
<font face="Arial" size="2">Todas los incidentes, problemas o indicadores relevantes detectados en el presente documento estan desarrollados e investigados en el documento adjunto a la presente Guia,</font>
<font face="Arial" size="2">y resultan en accionables que seran ejecutados segun cronograma vigente de actividades.</font></br>
<font face="Arial" size="2">El Dashboard de los servicios se encuentra en el cuerpo del correo electronico de cierre de Guia de Operaciones.</font>
</br>
</br>
<div class="filler"></div>

<div class="filler"></div>
<div class="filler"></div>
<div class="save">
<TABLE cellSpacing=0 cellPadding=0>
<TBODY>
<TR>
<TD>
<DIV id=objshowhide tabIndex=0><FONT face=Arial></FONT></DIV>
</TD>
</TR>
</TBODY>
</TABLE>
<DIV class=heading0_expanded>
<SPAN class=sectionTitle tabIndex=0>$target Detalles</SPAN>
</DIV>
<DIV class=filler></DIV>
<DIV class=container>
<DIV class=heading1>
<SPAN class=sectionTitle tabIndex=0>General</SPAN>
</DIV>
<DIV class=container>
<DIV class=tableDetail>
<TABLE>
<tr>
<th width='25%'><b>Computer Name</b></font></th>
<td width='75%'>$($Data.ComputerSystem.Name)</font></td>
</tr>
<tr>
<th width='25%'><b>Computer Role</b></font></th>
<td width='75%'> $($Data.ComputerRole) </font></td>
</tr>
<tr>
<th width='25%'><b>$($Data.CompType)</b></font></th>	
<td width='75%'>$($Data.ComputerSystem.Domain)</font></td>
</tr>
<tr>
<th width='25%'><b>Sistema Operativo</b></font></th>
<td width='75%'>$($Data.OperatingSystems.Caption)</font></td>
</tr>
<tr>
<th width='25%'><b>Service Pack</b></font></th>
<td width='75%'>$($Data.OperatingSystems.CSDVersion)</font></td>
</tr>
<tr>
<th width='25%'><b>System Root</b></font></th>
<td width='75%'>$($Data.OperatingSystems.SystemDrive)</font></td>
</tr>
<tr>
<th width='25%'><b>Manufacturer</b></font></th>
<td width='75%'>$($Data.ComputerSystem.Manufacturer)</font></td>
</tr>
<tr>
<th width='25%'><b>Model</b></font></th>
<td width='75%'>$($Data.ComputerSystem.Model)</font></td>
</tr>
<tr>
<th width='25%'><b>Number of Processors</b></font></th>
<td width='75%'>$($Data.ComputerSystem.NumberOfProcessors)</font></td>
</tr>
<tr>
<th width='25%'><b>Memory</b></font></th>
<td width='75%'>$([math]::round($Data.ComputerSystem.TotalPhysicalMemory/1073741824)) Gb</font></td>

</tr>
<tr>
<th width='25%'><b>Registered User</b></font></th>
<td width='75%'>$($Data.ComputerSystem.PrimaryOwnerName)</font></td>
</tr>
<tr>
<th width='25%'><b>Registered Organization</b></font></th>
<td width='75%'>$($Data.OperatingSystems.Organization)</font></td>
</tr>
<tr>
<th width='25%'><b>Ultimo reinicio</b></font></th>
<td width='75%'>$($Data.Uptime)</font></td>
</tr>
</TABLE>
</DIV>
</DIV>
<DIV class=filler></DIV>

<DIV class=container>
<DIV class=heading1>
<SPAN class=sectionTitle tabIndex=0>Actualizaciones instaladas</SPAN>
</DIV>
<DIV class=container>
<DIV class=tableDetail>
<TABLE>
<tr>
<th width='10%'><b>HotFix Number</b></font></th>
<th width='10%'><b>Descripcion</b></font></th>
<th width='10%'><b>Installed By</b></font></th>
<th width='10%'><b>Install Date</b></font></th>
</tr>
"@

    ForEach ($objQuickFix in $Data.colQuickFixes) {
        if ($objQuickFix.HotFixID -ne "File 1") {
            $Report += "				<tr>"
            $Report += "					<td width='10%'>$($objQuickFix.HotFixID)</font></td>"
            $Report += "					<td width='10%'>$($objQuickFix.Description)</font></td>"
            $Report += "					<td width='10%'>$($objQuickFix.InstalledBy)</font></td>"
            $Report += "					<td width='10%'>$($objQuickFix.InstalledOn)</font></td>"
            $Report += "				</tr>"
        }
    }
    $Report += @"
</TABLE>
</DIV>
</DIV>
</DIV>

<DIV class=filler></DIV>
<DIV class=container>
<DIV class=heading1>
<SPAN class=sectionTitle tabIndex=0>Espacio en disco</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
            <tr>
                  <th width='15%'><b>Drive Letter</b></font></th>
                  <th width='20%'><b>Label</b></font></th>
                  <th width='20%'><b>File System</b></font></th>
                  <th width='15%'><b>Disk Size</b></font></th>
                  <th width='15%'><b>Disk Free Space</b></font></th>
                  <th width='15%'><b>% Free Space</b></font></th>
              </tr>
"@

    Foreach ($objDisk in $Data.colDisks) {
        if ($objDisk.DriveType -eq 3) {
            $Report += "					<tr>"
            $Report += "						<td width='15%'>$($objDisk.DeviceID)</font></td>"
            $Report += " 						<td width='20%'>$($objDisk.VolumeName)</font></td>"
            $Report += " 						<td width='20%'>$($objDisk.FileSystem)</font></td>"
            $disksize = [math]::round(($objDisk.size / 1073741824))

            $Report += " 						<td width='15%'>$disksize Gb</font></td>"
            $freespace = [math]::round(($objDisk.FreeSpace / 1073741824))
            $Report += " 						<td width='15%'>$Freespace Gb</font></td>"
            $percFreespace = [math]::round(((($objDisk.FreeSpace / 1073741824) / ($objDisk.Size / 1073741824)) * 100), 0)
            $Report += " 						<td width='15%'>$percFreespace%</font></td>"
            $Report += "					</tr>"
        }
    }
    $Report += @"
</TABLE>
</DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>


<DIV class=container>
<DIV class=heading1>
    <SPAN class=sectionTitle tabIndex=0>Placas de red</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
"@
    Foreach ($objAdapter in $Data.colAdapters) {
        if ($objAdapter.IPEnabled -eq "True") {
            $NICCount = $NICCount + 1
            If ($NICCount -gt 1) {
                $Report += "			</TABLE>"
                $Report += "				<DIV class=Solidfiller></DIV>"
                $Report += "			<TABLE>"
            }
            $Report += "  					<tr>"
            $Report += "	 					<th width='25%'><b>Description</b></font></th>"
            $Report += "    					<td width='75%'>$($objAdapter.Description)</font></td>"
            $Report += "  					</tr>"
            $Report += "  					<tr>"
            $Report += "						<th width='25%'><b>Physical address</b></font></th>"
            $Report += "						<td width='75%'>$($objAdapter.MACaddress)</font></td>"
            $Report += " 					</tr>"
            If ($objAdapter.IPAddress -ne $Null) {
                $Report += "					<tr>"
                $Report += "						<th width='25%'><b>IP Address / Subnet Mask</b></font></th>"
                $Report += "						<td width='75%'>$($objAdapter.IPAddress)/$($objAdapter.IPSubnet)</font></td>"
                $Report += "					</tr>"
                $Report += "					</tr>"
                $Report += "					<tr>"
                $Report += "						<th width='25%'><b>Default Gateway</b></font></th>"
                $Report += "						<td width='75%'>$($objAdapter.DefaultIPGateway)</font></td>"
                $Report += "					</tr>"

            }
            $Report += "					<tr>"
            $Report += "						<th width='25%'><b>DHCP enabled</b></font></th>"
            If ($objAdapter.DHCPEnabled -eq "True") {
                $Report += "						<td width='75%'>Yes</font></td>"
            }
            Else {
                $Report += "						<td width='75%'>No</font></td>"
            }
            $Report += "					</tr>"
            $Report += "					<tr>"
            $Report += "							<th width='25%'><b>DNS Servers</b></font></th>"
            $Report += "							<td width='75%'>"
            If ($objAdapter.DNSServerSearchOrder -ne $Null) {
                $Report += " $($objAdapter.DNSServerSearchOrder) "
            }
            $Report += "					</tr>"
            $Report += "					<tr>"
            $Report += "						<th width='25%'><b>Primary WINS Server</b></font></th>"
            $Report += "						<td width='75%'>$($objAdapter.WINSPrimaryServer)</font></td>"
            $Report += "					</tr>"
            $Report += "					<tr>"
            $Report += "						<th width='25%'><b>Secondary WINS Server</b></font></th>"
            $Report += "						<td width='75%'>$($objAdapter.WINSSecondaryServer)</font></td>"
            $Report += "					</tr>"
            $NICCount = $NICCount + 1
        }  # if
    } # foreach report nics
    $Report += @"
        </TABLE>
    </DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>
"@	
    Write-Verbose "[PROCESS] Installed Software"

    $Report += @"
<DIV class=container>
    <DIV class=heading1>
        <SPAN class=sectionTitle tabIndex=0>Programas Instalados</SPAN>
    </DIV>
    <DIV class=container>
        <DIV class=tableDetail>
            <TABLE>
                <tr>
                      <th width='25%'><b>Name</b></font></th>
                      <th width='25%'><b>Vendor</b></font></th>
                </tr>
"@
    Foreach ($objApps in $Data.Programs) {
        $Report += "					<tr>"
        $Report += "						<td width='50%'>$($objApps.DisplayName)</font></td>"
        $Report += "						<td width='50%'>$($objApps.Publisher)</font></td>"
        $Report += "					</tr>"
    }
    $Report += "				</TABLE>"
    $Report += "			</DIV>"
    $Report += "		</DIV>"
    $Report += "	</DIV>"
    $Report += "	<DIV class=filler></DIV>"		
    $Report += @"
<DIV class=container>
<DIV class=heading1>
    <SPAN class=sectionTitle tabIndex=0>Carpetas compartidas</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
            <tr>
                  <th width='25%'><b>Share</b></font></th>
                  <th width='25%'><b>Path</b></font></th>
                  <th width='50%'><b>Comment</b></font></th>
            </tr>
"@
    Foreach ($objShare in $Data.colShares) {
        $Report += "					<tr>"
        $Report += "						<td width='25%'>$($objShare.Name)</font></td>"
        $Report += "						<td width='25%'>$($objShare.Path)</font></td>"
        $Report += "						<td width='50%'>$($objShare.Caption)</font></td>"
        $Report += "					</tr>"
    }	
    $Report += @"
        </TABLE>
    </DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>

<DIV class=container>
<DIV class=heading1>
    <SPAN class=sectionTitle tabIndex=0>Impresoras</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
            <tr>
                <th width='25%'><b>Printer</b></font></th>
                <th width='25%'><b>Location</b></font></th>
                <th width='25%'><b>Default Printer</b></font></th>
                <th width='25%'><b>Portname</b></font></th>
            </tr>
"@
    Foreach ($objPrinter in $Data.colInstalledPrinters) {
        If ($objPrinter.Name -eq "") {
            $Report += "					<tr>"
            $Report += "						<td width='100%'>No Printers Installed</font></td>"
        }
        Else {
            $Report += "					<tr>"
            $Report += "						<td width='25%'>$($objPrinter.Name)</font></td>"
            $Report += "						<td width='25%'>$($objPrinter.Location)</font></td>"
            if ($objPrinter.Default -eq "True") {
                $Report += "						<td width='25%'>Yes</font></td>"
            }
            Else {
                $Report += "						<td width='25%'>No</font></td>"
            }
            $Report += "						<td width='25%'>$($objPrinter.Portname)</font></td>"
        }
        $Report += "					</tr>"
    }
    $Report += @"
    </TABLE>
    </DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>
<DIV class=container>
<DIV class=heading1>
    <SPAN class=sectionTitle tabIndex=0>Servicios</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
              <tr>
                 <th width='20%'><b>Name</b></font></th>
                 <th width='20%'><b>Account</b></font></th>
                 <th width='20%'><b>Start Mode</b></font></th>
                 <th width='20%'><b>State</b></font></th>
              </tr>
"@

    Foreach ($objService in $Data.colListOfServices) {
        $Report += " 					<tr>"
        $Report += "	 					<td width='20%'>$($objService.Caption)</font></td>"
        $Report += "	 					<td width='20%'>$($objService.Startname)</font></td>"
        $Report += "	 					<td width='20%'>$($objService.StartMode)</font></td>"
        If ($objService.StartMode -eq "Auto") {
            if ($objService.State -eq "Stopped") {
                $Report += "						<td width='20%'><font color='#FF0000'>$($objService.State)</font></td>"
            }
        }
        If ($objService.StartMode -eq "Auto") {
            if ($objService.State -eq "Running") {
                $Report += "						<td width='20%'><font color='#009900'>$($objService.State)</font></td>"
            }
        }
        If ($objService.StartMode -eq "Disabled") {
            If ($objService.State -eq "Running") {
                $Report += "						<td width='20%'><font color='#FF0000'>$($objService.State)</font></td>"
            }
        }
        If ($objService.StartMode -eq "Disabled") {
            if ($objService.State -eq "Stopped") {
                $Report += "						<td width='20%'><font color='#009900'>$($objService.State)</font></td>"
            }
        }
        If ($objService.StartMode -eq "Manual") {
            $Report += "						<td width='20%'><font color='#009900'>$($objService.State)</font></td>"
        }
        If ($objService.State -eq "Paused") {
            $Report += "						<td width='20%'><font color='#FF9933'>$($objService.State)</font></td>"
        }
        $Report += "  					</tr>"
    }	
    $Report += @"
        </TABLE>
    </DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>
<DIV class=container>
<DIV class=heading1>
    <SPAN class=sectionTitle tabIndex=0>Configuracion Regional</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
             <tr>
                 <th width='25%'><b>Time Zone</b></font></th>
                 <td width='75%'>$($Data.TimeZone.Description)</font></td>
             </tr>
             <tr>
                 <th width='25%'><b>Country Code</b></font></th>
                 <td width='75%'>$($Data.OperatingSystems.Countrycode)</font></td>
             </tr>
             <tr>
                 <th width='25%'><b>Locale</b></font></th>
                 <td width='75%'>$($Data.OperatingSystems.Locale)</font></td>
             </tr>
             <tr>
                 <th width='25%'><b>Operating System Language</b></font></th>
                 <td width='75%'>$($Data.OperatingSystems.OSLanguage)</font></td>
             </tr>
             <tr>
             <th width='25%'><b>Keyboard Layout</b></font></th>
                 <td width='75%'>$($Data.objKeyboards)</font></td>
             </tr>
        </TABLE>
    </div>
</DIV>
</DIV>
<DIV class=filler></DIV>
<DIV class=container>
<DIV class=heading2>
    <SPAN class=sectionTitle tabIndex=0>Eventos de ERROR</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
              <tr>
                <th width='10%'><b>Event Code</b></font></th>
               <th width='10%'><b>Source Name</b></font></th>
                <th width='15%'><b>Time</b></font></th>
                <th width='10%'><b>Log</b></font></th>
                <th width='55%'><b>Message</b></font></th>
              </tr>
"@

    Write-Verbose "[PROCESS] print Event Log Warnings"


    $Array_Error = @()
    ForEach ($objEvent in $Data.colLoggedEvents) {
        $imprime = $false	
        $valorAct = $objEvent.EventCode

        $existe = $false
        ForEach ($val in $Array_Error) {
            If ( $val -eq $valorAct ) {		   		
                $existe = $true
                break
            }

        }
        if ($existe -eq $false) {
            $imprime = $true
            $Array_Error += $valorAct

        }


        if ($imprime -eq $true) {

            $dtmEventDate = $ObjEvent.ConvertToDateTime($objEvent.TimeWritten)
            $Report += " 					<tr>"
            $Report += "	 					<td width='10%'>$($objEvent.EventCode)</font></td>"
            $Report += "	 					<td width='10%'>$($objEvent.SourceName)</font></td>"
            $Report += "	 					<td width='15%'>$dtmEventDate</font></td>"
            $Report += "	 					<td width='10%'>$($objEvent.LogFile)</font></td>"
            $Report += "	 					<td width='55%'>$($objEvent.Message)</font></td>"
            $Report += "  					</tr>"

        }
    }

    $Report += @"
        </TABLE>
    </DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>
<DIV class=container>
<DIV class=heading2>
    <SPAN class=sectionTitle tabIndex=0>Eventos de WARNING</SPAN>
</DIV>
<DIV class=container>
    <DIV class=tableDetail>
        <TABLE>
              <tr>
                <th width='10%'><b>Event Code</b></font></th>
               <th width='10%'><b>Source Name</b></font></th>
                <th width='15%'><b>Time</b></font></th>
                <th width='10%'><b>Log</b></font></th>
                <th width='55%'><b>Message</b></font></th>
              </tr>
"@



    $Array_warning = @()
    ForEach ($objEvent in $Data.colEvents) {
        $imprime = $false	
        $valorAct = $objEvent.EventCode

        $existe = $false
        ForEach ($val in $Array_warning) {
            If ( $val -eq $valorAct ) {		   		
                $existe = $true
                break
            }

        }
        if ($existe -eq $false) {
            $imprime = $true
            $Array_warning += $valorAct

        }


        if ($imprime -eq $true) {

            $Report += " 					<tr>"
            $Report += "	 					<td width='10%'>$($objEvent.EventCode)</font></td>"
            $Report += "	 					<td width='10%'>$($objEvent.SourceName)</font></td>"
            $Report += "	 					<td width='15%'>$($dtmEventDate)</font></td>"
            $Report += "	 					<td width='10%'>$($objEvent.LogFile)</font></td>"
            $Report += "	 					<td width='55%'>$($objEvent.Message)</font></td>"
            $Report += "  					</tr>"

        }
    }

    $Report += @"
        </TABLE>
    </DIV>
</DIV>
</DIV>
<DIV class=filler></DIV>
    </DIV>
</DIV>
</DIV>

<DIV class=filler></DIV>
</body>
</html>
"@

    Write-Output $Report

}