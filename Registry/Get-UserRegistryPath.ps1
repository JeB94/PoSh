    IF (!(Test-Path -Path $PathUser)) {
        throw "User not logged to windows"
    }

    Write-Ve

}

