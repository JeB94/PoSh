
[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    $Number,

    [Parameter(Mandatory)]
    [String]$message,

    [Parameter(Mandatory)]
    $api,

    [Parameter(Mandatory)]
    $DeviceID,

    [Parameter(Mandatory)]
    $UserID
)

BEGIN {

    $Credential = New-Object System.Management.Automation.PSCredential ($api, (ConvertTo-SecureString $api -AsPlainText -Force))
}

PROCESS {

    $body = "{`"type`": `"push`",
       `"push`": 
        {`"type`": `"messaging_extension_reply`",
        `"package_name`": `"com.pushbullet.android`",
        `"source_user_iden`": `"$userID`",
        `"target_device_iden`": `"$deviceID`",
         `"conversation_iden`": `"$number`",
         `"message`": `"$message`" } }"

    $sendsms = @{
        contentType = "application/json"
        Body = $body
        Method = "Post"
        Credential = $Credential
        Uri = "https://api.pushbullet.com/v2/ephemerals"
    }
}

END {

    Invoke-RestMethod @sendsms

}
