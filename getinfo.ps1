<# GOALS: 
- Personal to Corporate
- Move 'Unassigned' device category devices into 'A&H' or 'SSCF' based on user OU.


So, get all users from A&H membership group, and then SSCF.
Potential for overlap, so maybe approach from the other end. 
Unassigned devices > check user affiliation > update device.
#>


# https://github.com/microsoft/mggraph-intune-samples/blob/main/ManagedDevices/ManagedDevices_Get.ps1
Import-Module Microsoft.Graph.DeviceManagement

# Requires perms: DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementConfiguration.Read.All,
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.devicemanagement/get-mgdevicemanagementmanageddevice?view=graph-powershell-1.0)
#Retrieve all managed devices by UPN of primary user
#Get-MgDeviceManagementManagedDevice -Filter "userPrincipalName eq '$UPN'"
# All params: https://learn.microsoft.com/en-us/graph/api/intune-devices-manageddevice-get?view=graph-rest-1.0#response-1
Get-MgDeviceManagementManagedDevice -Filter "deviceCategoryDisplayName eq '$UNASSIGNED'"


Import-Module Microsoft.Graph.Groups

# This requires GroupMember.Read.All permission 
# (https://learn.microsoft.com/en-us/graph/api/group-list-members?view=graph-rest-1.0&tabs=powershell)
Get-MgGroupMember -GroupId $groupId

# https://github.com/JayRHa/Intune-Scripts/blob/main/Change-DeviceCategory/Change-DeviceCategorySingle.ps1
# THIS NEEDS TO OCCUR IN BETA ENVIRONMENT (https://github.com/microsoft/Intune-PowerShell-SDK/issues/14)
# BETA DOES NOT SUPPORT PRODUCTION DEPLOYMENTS FOR NATIVE CMDLETS!!
# So we will make a REST call in beta and then revert back to 1.0.
function Change-DeviceCategory {
	param(
		[Parameter(Mandatory)]
		[string]$DeviceID,
		
		[Parameter(Mandatory)]
		[string]$DeviceCategory
	)

    Update-MSGraphEnvironment -SchemaVersion 'beta'
	
    $body = @{ "@odata.id" = "https://graph.microsoft.com/beta/deviceManagement/deviceCategories/$DeviceCategory" }
    Invoke-MSGraphRequest -HttpMethod PUT -Url "deviceManagement/managedDevices/$DeviceID/deviceCategory/`$ref" -Content $body

	Update-MSGraphEnvironment -SchemaVersion 'v1.0'
}

$DeviceID = 'ADD-DEVICE-ID'
$DeviceCategory = 'ADD-THE-DEVICE-CATEGORY-ID'

Change-DeviceCategory -DeviceID $DeviceID -DeviceCategory $DeviceCategory