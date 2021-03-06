﻿import-module sqlps;
$myData = invoke-sqlcmd -InputFile "Full Path to .SQL Query" -serverinstance -InstanceName -database DBToRunOn;
$mydata | out-file SaveLocationForQueryResults.sql;
remove-module sqlps;

$Username = "domain/acct";
$Password = "cred";
$path = "Path of Log Result to Send_$(get-date -f MM-dd).txt";

function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "alias@domain.com";
    $message.To.Add($email);
    $message.Subject = "Describe Sent Results";
    $message.Body = "";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);
    $smtp = new-object Net.Mail.SmtpClient("smtp.domain.com");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
 }
Send-ToEmail  -email "destination.domain.com" -attachmentpath $path;
