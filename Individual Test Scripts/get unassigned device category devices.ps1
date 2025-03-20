Connect-MgGraph #authenticate

# https://github.com/microsoft/mggraph-intune-samples/blob/main/ManagedDevices/ManagedDevices_Get.ps1
Import-Module Microsoft.Graph.DeviceManagement

# Requires perms: DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementConfiguration.Read.All,
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.devicemanagement/get-mgdevicemanagementmanageddevice?view=graph-powershell-1.0)
#Retrieve all managed devices by UPN of primary user
$UNASSIGNED = 'Unassigned'
Get-MgDeviceManagementManagedDevice -Filter "deviceCategoryDisplayName eq '$UNASSIGNED'"

pause