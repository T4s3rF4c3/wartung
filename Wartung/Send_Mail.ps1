<#
.SYNOPSIS

Send email with optional attachments

.DESCRIPTION

PowerShelll script for a function to send email with optional attachments. It accepts a comma-separated list of attachments, or no attachments at all.

For dot-source inclusion to work if the script is hosted on a UNC path, you may need to add the url "file:\\unc-path-to-share" to the Internet Explorer local Intranet site list on the server running the script.


.INPUTS

None

.OUTPUTS

None

.EXAMPLE

PS> .\Send-Email.ps1
Send-Email -EmailTo "user@yourdomain.co.uk" -EmailSubject "Log files attached" -EmailBody "Please find attached the log files" -EmailAttachments "C:\logs\Logfile.txt","C:\logs\Logfile2.txt"

This command sends an email with 2 attachments

.EXAMPLE

PS> .\Send-Email.ps1
$EmailRecipients = @("user@yourdomain.co.uk","user2@yourdomain.co.uk","admin@yourdomain.co.uk")
Send-Email -EmailTo $EmailRecipients -EmailSubject "Test message" -EmailBody "Hello"

These commands send an email to multiple recipients

.EXAMPLE

PS> .\Send-Email.ps1
Send-Email -EmailTo "user@yourdomain.co.uk" -EmailFrom "admin@yourdomain.co.uk" -EmailSMTPServer "mailserver.yourdomain.co.uk" -EmailSubject "Log file attached" -EmailBody "Please find attached the log file" -EmailAttachments "C:\logs\Logfile.txt"

This command shows all parameters

.LINK
https://www.techexplorer.co.uk/powershell-script-to-send-email-with-optional-attachments

#>



#--------------------------------------------------------------------------------
#        Script: Send-Email.ps1
#      Author: Dan Tonge, www.techexplorer.co.uk
#     Version:  1.0 2013-04-11
#     Version:  1.1 2015-06-01  Added multiple recipient syntax examples
#     Version:  1.2 2020-06-08  Added comment-based help for the script
#--------------------------------------------------------------------------------

Function Send-Email
{
    Param
        (
            [parameter(Mandatory=$true,HelpMessage="Email To Address")] $EmailTo,
            [parameter(HelpMessage="Email From Address")] $EmailFrom = [String]$env:computerName.ToLower() + '@DOMAIN.COM',
            [parameter()] $EmailSMTPServer = 'MAILSERVER',
            [parameter(Mandatory=$true,HelpMessage="Email subject line")] $EmailSubject,
            [parameter(Mandatory=$true,HelpMessage="Email content")] $EmailBody,
            [parameter(HelpMessage="Optional Attachments")] $EmailAttachments
         ) #end Param

    # build a "splat" parameter: a hash of {parameter name, parameter value} to avoid passing the Attachments parameter when not needed
    # http://stackoverflow.com/questions/14560270/send-mailmessage-attachments-will-not-accept-null-for-any-variables
    $attachments = @()
        if ($EmailAttachments) 
            {
                $attachments += $EmailAttachments
            }

    $params = @{}
        if ($attachments.Length -gt 0)
            {
                $params['Attachments'] = $attachments
            }

    Send-MailMessage @params -To $EmailTo -From $EmailFrom -SmtpServer $EmailSMTPServer -Subject $EmailSubject -Body $EmailBody
}