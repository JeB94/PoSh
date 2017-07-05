<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>
#Requires -RunAs

Get-AppxPackage | Where-Object name -notlike '*photos*' | 
    Where-Object name -notlike '*calculator*' | 
    Where-Object name -notlike '*store*' | 
    Remove-AppxPackage -ErrorAction SilentlyContinue 

