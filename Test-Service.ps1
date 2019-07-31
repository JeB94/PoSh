# Sites & subnets
Get-ADObject -LDAPFilter '(objectClass=site)' -SearchBase (Get-ADRootDSE).ConfigurationNamingContext -Properties WhenCreated, Description |
Select-Object *, `
    @{label='IsEmpty';expression={If ($(Get-ADObject -Filter {ObjectClass -eq "nTDSDSA"} -SearchBase $_.DistinguishedName)) {$false} else {$true}}}, `
    @{label='DCCount';expression={@($(Get-ADObject -Filter {ObjectClass -eq "nTDSDSA"} -SearchBase $_.DistinguishedName)).Count}}, `
    @{label='SubnetCount';expression={@($(Get-ADObject -Filter {ObjectClass -eq "subnet" -and siteObject -eq $_.DistinguishedName} -SearchBase (Get-ADRootDSE).ConfigurationNamingContext)).Count}}, `
    @{label='SiteLinkCount';expression={@($(Get-ADObject -Filter {ObjectClass -eq "sitelink" -and siteList -eq $_.DistinguishedName} -SearchBase (Get-ADRootDSE).ConfigurationNamingContext)).Count}} |
Sort-Object Name |
Format-List Name, SiteLinkCount, SubnetCount, DCCount, IsEmpty, WhenCreated, Description -Autosize
