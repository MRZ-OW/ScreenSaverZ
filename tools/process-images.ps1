Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic
Set-Location -Path $PSScriptRoot

function Command-Exists { param ($Command) return (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null }

# Install ImageMagick if missing
if (-not (Command-Exists "magick")) {
    [System.Windows.Forms.MessageBox]::Show("ImageMagick not found. Installing...", "Installing", "OK", "Information")
    if (Command-Exists "winget") {
        winget install -e --id ImageMagick.ImageMagick --accept-package-agreements --accept-source-agreements
    } else {
        [System.Windows.Forms.MessageBox]::Show("winget not found. Install ImageMagick manually.","Error","OK","Error")
        exit 1
    }
}

# Ordered Kindle resolutions
$resolutionOrder = @(
    "Kindle 1 (2007)","Kindle 2 (2009)","Kindle 4 (2011)","Kindle 5 (2012)",
    "Kindle 7 (2014)","Kindle 8 (2016)","Kindle 10 (2019)","Kindle 11 (2022)","Kindle 2024",
    "Kindle Paperwhite (1st Gen)","Kindle Paperwhite (2nd Gen)","Kindle Paperwhite (3rd Gen)",
    "Kindle Paperwhite (4th Gen)","Kindle Paperwhite (5th Gen / 11th Gen)","Kindle Paperwhite 5 Signature Edition",
    "Kindle Paperwhite (6th Gen / 12th Gen)","Kindle Paperwhite 6 Signature Edition",
    "Kindle Oasis (1st Gen)","Kindle Oasis (2nd Gen)","Kindle Oasis (3rd Gen)",
    "Kindle Voyage","Kindle DX","Kindle Keyboard (Kindle 3)",
    "Kindle Scribe","Kindle Scribe 2024","Kindle Scribe Colorsoft","Kindle Scribe 3","Kindle Scribe 3 without Front Light",
    "Kindle Colorsoft","Kindle Colorsoft Signature Edition",
    "Custom"
)

# Resolution hash
$resolutions = @{
    "Kindle 1 (2007)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 2 (2009)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 4 (2011)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 5 (2012)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 7 (2014)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 8 (2016)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 10 (2019)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 11 (2022)" = @{Width=1072; Height=1448; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle 2024" = @{Width=1072; Height=1448; Type="Mono"; Dither="FloydSteinberg"}

    "Kindle Paperwhite (1st Gen)" = @{Width=758; Height=1024; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite (2nd Gen)" = @{Width=758; Height=1024; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite (3rd Gen)" = @{Width=1072; Height=1448; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite (4th Gen)" = @{Width=1072; Height=1448; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite (5th Gen / 11th Gen)" = @{Width=1236; Height=1648; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite 5 Signature Edition" = @{Width=1236; Height=1648; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite (6th Gen / 12th Gen)" = @{Width=1264; Height=1680; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Paperwhite 6 Signature Edition" = @{Width=1264; Height=1680; Type="Mono"; Dither="FloydSteinberg"}

    "Kindle Oasis (1st Gen)" = @{Width=1072; Height=1448; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Oasis (2nd Gen)" = @{Width=1264; Height=1680; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Oasis (3rd Gen)" = @{Width=1264; Height=1680; Type="Mono"; Dither="FloydSteinberg"}

    "Kindle Voyage" = @{Width=1072; Height=1448; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle DX" = @{Width=824; Height=1200; Type="Mono"; Dither="FloydSteinberg"}
    "Kindle Keyboard (Kindle 3)" = @{Width=600; Height=800; Type="Mono"; Dither="FloydSteinberg"}

    "Kindle Scribe" = @{Width=1860; Height=2480; Type="ColorFull"; Dither=""}
    "Kindle Scribe 2024" = @{Width=1860; Height=2480; Type="ColorFull"; Dither=""}
    "Kindle Scribe Colorsoft" = @{Width=1980; Height=2640; Type="ColorSoft"; Dither="Riemersma"}
    "Kindle Scribe 3" = @{Width=1980; Height=2640; Type="ColorSoft"; Dither="Riemersma"}
    "Kindle Scribe 3 without Front Light" = @{Width=1980; Height=2640; Type="ColorSoft"; Dither="Riemersma"}

    "Kindle Colorsoft" = @{Width=1264; Height=1680; Type="ColorSoft"; Dither="Riemersma"}
    "Kindle Colorsoft Signature Edition" = @{Width=1264; Height=1680; Type="ColorSoft"; Dither="Riemersma"}

    "Custom" = @{Width=0; Height=0; Type="Mono"; Dither="FloydSteinberg"}
}

do {
    # Form and dropdown
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Kindle Model"
    $form.Size = New-Object System.Drawing.Size(400,280)
    $form.StartPosition = "CenterScreen"

    $combo = New-Object System.Windows.Forms.ComboBox
    $combo.Location = New-Object System.Drawing.Point(20,20)
    $combo.Size = New-Object System.Drawing.Size(340,30)
    $combo.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    foreach ($k in $resolutionOrder) { $combo.Items.Add($k) }
    $form.Controls.Add($combo)

    # OK Button
    $buttonOK = New-Object System.Windows.Forms.Button
    $buttonOK.Text = "OK"; $buttonOK.Location = New-Object System.Drawing.Point(20,70)
    $buttonOK.Add_Click({$form.Tag="ok"; $form.Close()})
    $form.Controls.Add($buttonOK)

    # Preview Button (updated text)
    $buttonPreview = New-Object System.Windows.Forms.Button
    $buttonPreview.Text = "Preview"; $buttonPreview.Location = New-Object System.Drawing.Point(150,70)
    $buttonPreview.Add_Click({$form.Tag="preview"; $form.Close()})
    $form.Controls.Add($buttonPreview)

    # Cancel Button
    $buttonCancel = New-Object System.Windows.Forms.Button
    $buttonCancel.Text = "Cancel"; $buttonCancel.Location = New-Object System.Drawing.Point(300,70)
    $buttonCancel.Add_Click({$form.Tag="cancel"; $form.Close()})
    $form.Controls.Add($buttonCancel)

    $form.ShowDialog() | Out-Null
    $selected = $combo.SelectedItem
    $action = $form.Tag
    if (-not $selected -or $action -eq "cancel") { break }

    # Handle Custom
    if ($selected -eq "Custom") {
        do { $width = [int][Microsoft.VisualBasic.Interaction]::InputBox("Enter width (positive integer):", "Custom Width", "1264") } while ($width -le 0)
        do { $height = [int][Microsoft.VisualBasic.Interaction]::InputBox("Enter height (positive integer):", "Custom Height", "1680") } while ($height -le 0)
        $type = "Mono"
        $dither = "FloydSteinberg"
    } else {
        $width = $resolutions[$selected].Width
        $height = $resolutions[$selected].Height
        $type = $resolutions[$selected].Type
        $dither = $resolutions[$selected].Dither
    }

    # Collect images, ignoring PreviewImage.png
    $images = Get-ChildItem *.png | Where-Object { $_.Name -ne "PreviewImage.png" } | Sort-Object Name
    $total = $images.Count
    if ($total -eq 0) { [System.Windows.Forms.MessageBox]::Show("No PNG files found.","Nothing to do","OK","Warning"); continue }

    # Ensure ProcessedImages folder exists
    $processedFolder = Join-Path $PSScriptRoot "ProcessedImages"
    if (-not (Test-Path $processedFolder)) { New-Item -Path $processedFolder -ItemType Directory | Out-Null }

    # Function to process an image
    function Process-Image($img, $outputFile) {
        $info = & magick identify -format "%w %h" "$($img.FullName)" 2>$null
        $origWidth, $origHeight = $info -split " " | ForEach-Object {[int]$_}

        if (($origWidth -gt $origHeight -and $width -lt $height) -or ($origHeight -gt $origWidth -and $height -lt $width)) {
            $resizeParam = "${width}x${height}"
        } else {
            $resizeParam = "${width}x${height}`^"
        }

        $magickArgs = @(
            "$($img.FullName)","-strip","-resize",$resizeParam,
            "-gravity","center","-extent","${width}x${height}","-depth","8","-alpha","off"
        )

        if ($type -eq "Mono") {
            $magickArgs += "-colorspace"; $magickArgs += "Gray"
            $magickArgs += "-auto-level"
            $magickArgs += "-contrast-stretch"; $magickArgs += "0.5%x0.5%"
            $magickArgs += "-gamma"; $magickArgs += "0.95"
            $magickArgs += "-dither"; $magickArgs += $dither
        } elseif ($type -eq "ColorSoft" -and $dither) {
            $magickArgs += "-dither"; $magickArgs += $dither
        }

        $magickArgs += $outputFile
        & magick @magickArgs 2>$null
    }

    # Handle preview
    if ($action -eq "preview") {

        $previewFile = Join-Path $PSScriptRoot "PreviewImage.png"
        if (Test-Path $previewFile) { Remove-Item $previewFile -Force }

        Process-Image $images[0] $previewFile

        $previewForm = New-Object System.Windows.Forms.Form
        $previewForm.Text = "Preview"
        $previewForm.StartPosition = "CenterScreen"
        $previewForm.Size = New-Object System.Drawing.Size(600,850)

        $pictureBox = New-Object System.Windows.Forms.PictureBox
        $pictureBox.Dock = "Top"
        $pictureBox.SizeMode = "Zoom"
        $pictureBox.Height = 700

        $imgObj = [System.Drawing.Image]::FromFile($previewFile)
        $pictureBox.Image = $imgObj
        $previewForm.Controls.Add($pictureBox)

        $label = New-Object System.Windows.Forms.Label
        $label.Text = "Dimensions: $($imgObj.Width) x $($imgObj.Height)"
        $label.AutoSize = $true
        $label.TextAlign = "MiddleCenter"
        $label.Dock = "Top"
        $label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
        $previewForm.Controls.Add($label)

        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Text = "OK"; $okButton.Dock = "Bottom"; $okButton.Height = 40
        $okButton.Add_Click({
            $imgObj.Dispose()
            $previewForm.Close()
        })
        $previewForm.Controls.Add($okButton)

        $previewForm.ShowDialog() | Out-Null
        continue
    }

    # Batch processing
    $i = 0
    foreach ($img in $images) {
        $percent = [int](($i / $total) * 100)
        Write-Progress -Activity "Processing images" -Status "$($img.Name) ($($i+1) of $total)" -PercentComplete $percent

        $outputFile = Join-Path $processedFolder ("bg_ss{0:D2}.png" -f $i)
        Process-Image $img $outputFile

        $i++
    }

    Write-Progress -Activity "Processing images" -Completed
    [System.Windows.Forms.MessageBox]::Show("Processing complete!`n$total images processed.`nSaved in ProcessedImages folder.","Done","OK","Information")

} while ($true)
