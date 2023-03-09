# Storyline: Send an email.
# Variable can have an underscore or any alphanumeric value.

# Body of the email
$msg = "Hello there General Grievous."

# Echoing to the screen.
write-host -BackgroundColor Red -ForegroundColor White $msg

# Email From Address
$email = "ricky.ninh@mymail.champlain.edu"

# To Address
$toEmail = "deployer@csi-web"

# Sending the email
Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" -Body $msg -SmtpServer 192.168.6.71