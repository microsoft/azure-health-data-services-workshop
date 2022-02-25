# Uninstall-AzureRM
# Uninstall-Module AzureRM
# Install-Module AZ -AllowClobber
# choco install nodejs

# Assuming you are running this code in the Hackathon VM
. C:\LabFiles\AzureCreds.ps1

$cred = $null
$SecurePassword = $AzurePassword | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AzureUserName, $securePassword

Login-AzAccount -Credential $cred | Out-Null

$token = (Get-AzAccessToken -ResourceUrl 'https://dicom.healthcareapis.azure.com').Token
$headers = @{Authorization="Bearer $token"}
Invoke-WebRequest -Method GET -Headers $headers -Uri 'https://<UPDATE-DICOM-HOSTNAME>.dicom.azurehealthcareapis.com/v1/changefeed'

$token

Logout-AzAccount | Out-Null
