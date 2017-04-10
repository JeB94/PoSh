[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    [String]$message,

    [Parameter(Mandatory)]
    [String]$title,

    [Parameter(Mandatory)]
    $api,

    [Parameter(Mandatory)]
    $DeviceID

)

BEGIN {

    $Credential = New-Object System.Management.Automation.PSCredential ($api, (ConvertTo-SecureString $api -AsPlainText -Force))

}

PROCESS { 
    
    $body = "{`"type`": `"note`",
                `"body`":`"$message`",
                `"title`":`"$title`",
            `"target_device_iden`": `"$deviceID`"}"

    $sendsms = @{
        contentType = "application/json"
        Body = $body
        Method = "Post"
        Credential = $Credential
        Uri = "https://api.pushbullet.com/v2/pushes"
    }
}

END { 
    Invoke-RestMethod @sendsms
}
