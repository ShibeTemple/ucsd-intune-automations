Get-Content ..\icf-automation.env | foreach {
  $name, $value = $_.split('=')
  if ([string]::IsNullOrWhiteSpace($name) || $name.Contains('#')) {
    return
	echo "skipping empty env line"
  }
  Set-Content env:\$name $value
  echo "hello"
  echo "var: $name $value"
}

echo "continue?"
pause

Connect-MgGraph -ClientID $env:MG_CLIENT_ID -TenantId $env:MG_TENANT_ID -CertificateThumbprint $env:MG_CERTIFICATE_THUMBPRINT

# https://github.com/microsoft/mggraph-intune-samples/blob/main/ManagedDevices/ManagedDevices_Get.ps1
Import-Module Microsoft.Graph.DeviceManagement

# Requires perms: DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementConfiguration.Read.All,
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.devicemanagement/get-mgdevicemanagementmanageddevice?view=graph-powershell-1.0)
#Retrieve all managed devices by UPN of primary user
$UNASSIGNED = 'Unassigned'
Get-MgDeviceManagementManagedDevice -Filter "deviceCategoryDisplayName eq '$UNASSIGNED'"

pause