#PowerShell Commands to create infrastructure for Backup lab.
#Make sure to install the VS Code extension for PowerShell or use Visual Studio
#Tip: Show the Integrated Terminal from View\Integrated Terminal
#Tip: click on a line and press "F8" to run the line of PowerShell code

#Make sure you are running the latest version of the Azure PowerShell modules. If unsure, uncomment the line below and run 
#it (F8)
#Install-Module -Name AzureRM -Force -Scope CurrentUser -AllowClobber

#Step 1: Create ResourceGroup. Use Get-AzureRmLocation to see a list of available regions.
Connect-AzureRmAccount
Get-AzureRmSubscription
#Copy the Subscription Id from the subscription you will use or copy from the portal.
Select-AzureRmSubscription -SubscriptionId 'changeme'
New-AzureRMResourceGroup -Name 'changeme' -Location 'East US'

#Step 2: Run deployment below after updating and SAVING the parameter file with the environment prefix.  
#Make sure to update the paths to the json files or run the command from the same directory.
#Note: You may want to adjust the VM series deployed in the ARM template. Feel free to modify the ARM template to use a 
#different VM Series.
New-AzureRmResourceGroupDeployment -Name 'changeme' -ResourceGroupName 'changeme' -TemplateFile '.\bkup-azuredeploy.json' `
-TemplateParameterFile '.\bkup-parameters.json' -Force -Verbose -ErrorVariable ErrorMessages
