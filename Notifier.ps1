#SMTP Server infos example:https://support.google.com/a/answer/176600
#For Gmail  lesssecureapps should be enabled
$emailSmtpServer = "smtp.gmail.com"
$emailSmtpServerPort = "587"
#Replace myemail and password
$emailSmtpUser = "myemail@gmail.com"
$emailSmtpPass = "password"

# INIT Mail
#Replace receiver@mail.com
$emailSendTo = "receiver@mail.com";
$emailMessage = New-Object System.Net.Mail.MailMessage
$emailMessage.From = "Notifier <$emailSmtpUser>"
$emailMessage.To.Add( $emailSendTo  )
$emailMessage.Subject = "Notif Farm"
$emailMessage.IsBodyHtml = $true
$emailMessage.Body = "Check your farm! :)";

#Replace Windows User name
$userName = "home"

$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
#pattern
#$patternStr ="1 proof"
$patternStr ="farmed unfin"

try
{
	Write-Host "To Exit press CTRL C"
	Write-Host "Begin reading";
	Get-Content -Path "C:\Users\$userName\.chia\mainnet\log\debug.txt*"  -wait -tail 1 | ? { $_ -match $patternStr } | % { Write-Host $_;  $SMTPClient.Send( $emailMessage )}
}
catch [System.IO.FileNotFoundException]
{
	Write-Host "Error reading logs";
}
Finally
{
	Write-Host "Error while reading logs:Reboot script";
	#$emailMessage.Subject = "Error log"
	#$emailMessage.Body = "Notifier Exception"
	#$SMTPClient.Send( $emailMessage )
	Start-Sleep -s 5
	$PSScriptRoot 
	$ScriptToRun= $PSScriptRoot+"\Notifier.ps1"
	&$ScriptToRun
}
