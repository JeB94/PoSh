[CmdletBinding()]
    param
    (
        $api
    )

    BEGIN {
        $Credential = New-Object System.Management.Automation.PSCredential ($api, (ConvertTo-SecureString $api -AsPlainText -Force))
    }
    PROCESS { 

        $sendsms = @{
            contentType = "application/json"
            Method = "Get"
            Credential = $Credential
            Uri = "https://api.pushbullet.com/v2/chats"
        }
    }
    END { 
        Invoke-RestMethod @sendsms
    }

