function Remove-ADGroupDisabledMember {
    <#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER SearchBase 
    
    .PARAMETER Filter

    .EXAMPLE

    .NOTES
#>

#Requires -Module ActiveDirectory
    [CmdletBinding()]
    param (
        $SearchBase,

        $Filter = "*"
    )

    process {

        $GroupParameter = @{
            Filter = $Filter
        }		

        if ($PSBoundParameters.ContainsKey("SearchBase")) {
            $GroupParameter.Add("SearchBase", $SearchBase)
        }

        try {
            Write-Verbose "[BEGIN] Getting groups"
            $Groups = Get-ADGroup @GroupParameter -ErrorAction Stop

            Foreach ($Group in $Groups) {
                Write-Verbose "[PROCESS] Retriving members from $Group"
                try {
                    $Members = Get-ADGroupMember -Identity $Group -Recursive
                    Foreach ($Member in $Members) {
                        try {
                            $User = Get-ADUser -Identity $Member -ErrorAction Stop
                            if (!($User.Enabled)) {
                                Write-Verbose "Removing $($User.Name) from $Group"
                                Remove-ADGroupMember -Identity $Group -Members $User.SamAccountName -Confirm:$False
                            } # if User enabled
                        } catch { 
                            Write-Warning "$Member it's not a user"
                        }
                    } # foreach members
                } catch {
                    Write-Warning "$Group it's not a group"
                }
            } # foreach groups			
        } catch {
            Write-Error $Error.Message
        } # try catch
    } #process
	
} # function