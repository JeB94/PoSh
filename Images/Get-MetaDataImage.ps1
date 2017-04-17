[CmdletBinding()]

Param ( 

    [Parameter(Mandatory)]
    [string[]]$File
   
)

BEGIN {

    IF (!(Test-Path $File)) {
        throw "No se encuentra archivo"
        break
    }
} 

PROCESS {

    $itemFile = Get-Item -Path $File
    $objectShell = New-Object -ComObject Shell.Application 

    $objectFolder = $objectShell.namespace($itemFile.DirectoryName) 

    foreach ($Item in $objectfolder.items()) {  
        IF ($item.Path -eq $File) {
           $FileMetaData = New-Object PSObject

            for ($a = 0 ; $a -le 266; $a++) {  
                if ($objectfolder.getDetailsOf($Item, $a)) { 
                  $hashTable = @{
                        $objectfolder.GetDetailsOf($objectfolder.items,$a) = $objectfolder.GetDetailsOf($Item, $a)
                    }
                    $FileMetaData | Add-Member $hashTable
                } #end if 
            } #end for  
            break
        }
    }
}

END {

    Write-Output $FileMetaData

}
