[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [Alias('Computers', 'servers')]
    [String[]]
    $ComputerName

)

WorkFlow Test-Service {
    param ($ComputerName)
    ForEach -parallel ($computer in $ComputerName) {
        InlineScript {
            
            Write-verbose "Testing services for $using:computer"

            # exluded services
            $ExcludeService = @('clr_optimization_v4.0.30319_32',
                'clr_optimization_v4.0.30319_64', 'gupdate',
                'sppsvc', 'msiserver', 'mmcss',
                'remoteregistry', 'iphlpsvc', 'mapsbroker',
                'rasman', 'rasauto', 'wlms', 'wbiosrvc',
                'wuauserv', 'tiledatamodelsvc', 'tbs', 'gisvc',
                'CDPSvc', 'msdtc', 'IaasVmProvider', 'bits', 'TrustedInstaller',
                'MSExchangeNotificationsBroker', 'DbgSvc', 'ShellHWDetection',
                'PrintNotify', 'RdSessMgr', 'gpsvc','ds_agent','ntrtscan')
                
            try {
                # get automatic services not excluded
                $wmiService = Get-WmiObject -Class win32_service -computerName $using:computer -ErrorAction Stop |
                Where-Object { $_.startmode -eq 'auto' -and $_.state -ne 'running' -and $_.name -notin $ExcludeService } 

                $wmiOS = Get-WmiObject win32_operatingsystem -computerName $using:Computer -ErrorAction Stop

                if ($null -ne $wmiService) {

                    $Property = @{
                        
                        ServiceName    = $wmiService.name
                        State          = $wmiService.state
                        DisplayName    = $wmiService.DisplayName
                        ComputerName   = $using:Computer
                        LastBootupTime = $WmiOS.ConverttoDateTime($wmiOS.LastBootUpTime)
                    }
                    $Object = New-Object PSCustomObject -Property $Property
                    Write-Verbose "Outputing computer $using:computer"
                    Write-Output $Object
                }
                else {
                    Write-Verbose "All automatic services are runing on $using:Computer"

                }

            }
            catch [System.Runtime.InteropServices.COMException] {
                # You can inspect the error code to see what specific error we're dealing with 
                if ($_.Exception.ErrorCode -eq 0x800706BA) {
                    # This is instead of the "RPC Server Unavailable" error
                    Write-Error -Message "Cannot connect to computer $using:Computer. Check if computer exist, is running and the network connection." 
                }
                else {
                    $errorMessage = $_.exception.Message 
                    Write-Error "$using:Computer $errorMessage" 
                }
            }
            catch {
                $errorMessage = $_.exception.Message 
                Write-Error "$using:Computer $errorMessage" 
            } # try catch
        } # inline script
    } # Foreach
        
} # workflow

Test-Service -ComputerName $ComputerName