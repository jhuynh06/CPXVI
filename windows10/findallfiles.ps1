$Folder = 'C:\images'
if (-Not(Test-Path -Path $Folder)) {
    New-Item -Path 'c:\images' -ItemType Directory
}
Get-ChildItem -Recurse c:\Users $originalPath -Include @("*.png", "*.jpg", "*.gif", "*.webp", "*.tiff", "*.psd", "*.raw", "*.txt", "*.bmp", "*.heif", "*.pdf", "*.mp3", "*.ogg", "*.wav", "*.aif", "*.7z", "*.tar.gz", "*.deb", "*.pkg", "*.rar", "*.zip", "*.iso", "*.mp4", "*.mpg", "*.h264", "*.mov", "*.mkv", "*.avi", "*.doc", "*.docx", "*.ppt", "*.pptx", "*.html")  | % {
    $image = [System.Drawing.Image]::FromFile($_.FullName)
    if ($image.width -gt 0 -and $image.height -gt 0) {
        New-Object PSObject -Property @{
		height_pixels = $image.Height
		width_pixels = $image.Width
		megapixels = ($image.Height * $image.Width)/1000/1000
		megabytes = (($_.Length)/1024)/1024
		name = $_.Name
		fullname = $_.Fullname
		date = $_.LastWriteTime
        }
    }
} | Export-Csv 'c:\images\img.csv' -NoTypeInformation
