Param(
    [Parameter(Mandatory)]
    [string[]]$file
   
)
 
IF (!(Test-Path $File)) {
    throw "No se encuentra archivo"
    break
}
$item = Get-Item -Path $File
$objShell = New-Object -ComObject Shell.Application 
$objFolder = $objShell.namespace($item.DirectoryName) 

foreach ($F in $objFolder.items()) {  
    IF ($F.Path -eq $File) {
        $FileMetaData = New-Object PSOBJECT 
        for ($a ; $a -le 266; $a++) {  
            if ($objFolder.getDetailsOf($F, $a)) { 
                $hash += @{$($objFolder.getDetailsOf($objFolder.items, $a)) = 
                    $($objFolder.getDetailsOf($F, $a)) 
                } 
                $FileMetaData | Add-Member $hash 
                $hash.clear()  
            } #end if 
        } #end for  
        $a = 0 
        $FileMetaData 
        break
    }
}
#end foreach $file 