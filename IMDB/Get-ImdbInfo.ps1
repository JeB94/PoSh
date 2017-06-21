param
(
    [Parameter(Mandatory)]
    [String]$Title ,
    
    [ValidateSet ("movie", "series")]
    $type , 
    
    [ValidateSet ("full", "short")]
    $Plot = "short" ,
    
    [Switch]$Tomatoes

)
$string = $title.replace(" ", "+")

$uri = "http://www.omdbapi.com/?t=$string&y=&plot=$Plot&r=json&type=$type"
IF ($Tomatoes) {
    $uri += "&tomatoes=true"
}

$Resq = Invoke-RestMethod -Uri $Uri

IF ($Resq.response -eq "True")
{
    Write-Output -InputObject $Resq
}
else {
    Write-Output -InputObject $Resq.error
}




