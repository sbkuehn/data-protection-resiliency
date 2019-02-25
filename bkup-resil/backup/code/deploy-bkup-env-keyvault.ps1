#Only run through these PowerShell commands if you are familiar with Key Vault and know how to reference the Key Vault in
#the parameters file for the ARM Template.

#PowerShell Commands to create an Azure Key Vault and deployment for Backup lab.
#Make sure to install the VS Code extension for PowerShell or use Visual Studio
#Tip: Show the Integrated Terminal from View\Integrated Terminal
#Tip: click on a line and press "F8" to run the line of PowerShell code

#Make sure you are running the latest version of the Azure PowerShell modules, uncomment the line below and run it (F8)
# Install-Module -Name AzureRM -Force -Scope CurrentUser -AllowClobber

#Step 1: Change everything with 'changeme' within the variable declaration. For lab name, use a name no longer then five 
#charactors all lowercase. Your initials would work well if working in the same sub as others.
$LabName = 'changeme'
$subscriptionId = 'changeme'
$location = 'East US'

#Step 2: Create ResourceGroup after updating the location to one of your choice. Use Get-AzureRmLocation to see a list
Connect-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId $subscription
New-AzureRMResourceGroup -Name $LabName -Location $location

#Step 3: Create Key Vault and set flag to enable for template deployment with ARM
$LabKVName = $LabName + 'bkresl'
New-AzureRmKeyVault -VaultName $LabKVName -ResourceGroupName $LabName -Location `
$location -EnabledForTemplateDeployment

#Step 4: Add password as a secret.  Note:this will prompt you for a user and password.  The easiest would be vmadmin 
#and a password that meets the azure pwd policies like P@ssw0rd123!! You will reference this in the bckup-parameters.json 
#file.
Set-AzureKeyVaultSecret -VaultName $LabKVName -Name "VMPassword" -SecretValue (Get-Credential).Password

#Step 5: Update bckup-parameters.json file with your envPrefixName and Key Vault info example: 
#/subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
(Get-AzureRmKeyVault -VaultName $LabKVName).ResourceId

#Step 6: Run deployment below after updating and SAVING the parameter file with your key vault info.  Make sure to update the 
#paths to the json files or run the command from the same directory.
#Note: You may want to adjust the VM series deployed in the ARM template. Feel free to modify the ARM template to use a 
#different VM Series.
New-AzureRmResourceGroupDeployment -Name $LabName -ResourceGroupName $LabName -TemplateFile '.\bkup-azuredeploy.json' `
-TemplateParameterFile '.\bkup-keyvault-parameters.json' -Force -Verbose -ErrorVariable ErrorMessages
