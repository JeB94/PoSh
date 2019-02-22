### General Servicios ###
    # posh 2.0 (2008r2)
    gwmi win32_service | ? {$_.startmode -eq 'auto' -and $_.state -ne 'running'}

    # posh 3.0 o superior
    gsv | ? { $_.starttype -eq 'automatic' -and $_.status -ne 'running'}

    get-service "nombre"  | stop-service    # detiene un servicio
    get-service "nombre"  | restart-service # reinicia un servicio
    get-service "nombre"  | start-service   # inicia un servicio

### Procesos ###
Get-process
Get-process "nombre" | stop-process # mata un proceso

# process explorer
https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer
detalle de procesos

# process  monitor
https://docs.microsoft.com/en-us/sysinternals/downloads/procmon

### IIS ###
# Existen dos modulos de IIS: WebAdministration (WS 2012R2) y IISAdministration (WS2016/2019)

# WebAdministration
    # Estado de App Pool
    Get-webapppoolState

    # Web Sites
    Get-WebSite

# IISAdministration
    # Estado de AppPool
    Get-IISAppPool

    # Web Sites
    Get-IISSite

### Active Directory ###

# replicación:
#1) Replication Status tool https://www.microsoft.com/en-us/download/details.aspx?id=30005

#2) dcdiag
       dcdiag /q # solo traera errores
       
#3) repadmin
repadmin /replsum # muestra estado de replicación del forest
repadmin /showrepl # muestra estado de replicación entrante
repadmin /kcc * # forza el KCC
repadmin /syncall /force # forza replicación

# sync de hora
w32tm /query /status # muestra estado actual de sincronizacion
w32tm /query /source # muestra el source de la sync de hora del servidor
w32tm /query /configuration # muestra configuracion actual de hora
    
    





