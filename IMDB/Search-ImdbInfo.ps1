param
(
    [Parameter ( Mandatory = $True)]
    [String]$Title
)
$string = $title.replace(" ", "+")

$uri = "http://www.omdbapi.com/?s=$string"
$Resq = Invoke-RestMethod -Uri $Uri
IF ($Resq.response)
{
Write-Output -InputObject $Resq.search  
}
else {
    Write-Output -InputObject $Resq.error
}
