function Resize-Image {
    param (          
        [string]$InputFile,

        [Parameter(Mandatory)]
        [string]$OutputFile,

        [int32]$Width,

        [int32]$Height,

        [int32]$Scale )

    # Add System.Drawing assembly
    Add-Type -AssemblyName System.Drawing

    # Open image file
    $img = [System.Drawing.Image]::FromFile((Get-Item $InputFile))


    # Define new resolution
    if ($Width -gt 0)
    { [int32]$new_width = $Width }
    elseif ($Scale -gt 0) { [int32]$new_width = $img.Width * ($Scale / 100) }
    else { [int32]$new_width = $img.Width / 2 }
    if ($Height -gt 0) { [int32]$new_height = $Height }
    elseif ($Scale -gt 0) { [int32]$new_height = $img.Height * ($Scale / 100) }
    else { [int32]$new_height = $img.Height / 2 }

    # Create empty canvas for the new image
    $img2 = New-Object System.Drawing.Bitmap($new_width, $new_height)

    # Draw new image on the empty canvas
    $graph = [System.Drawing.Graphics]::FromImage($img2)
    $graph.DrawImage($img, 0, 0, $new_width, $new_height)

    # Save the image
    if ($OutputFile -ne "") {
        $img2.Save($OutputFile);
    }
}
