Update-MSGraphEnvironment -SchemaVersion 'beta'


function Change-DeviceCategory {
	param(
		[Parameter(Mandatory)]
		[string]$DeviceID,
		
		[Parameter(Mandatory)]
		[string]$DeviceCategory
	)

    
    $body = @{ "@odata.id" = "https://graph.microsoft.com/beta/deviceManagement/deviceCategories/$DeviceCategory" }
    Invoke-MSGraphRequest -HttpMethod PUT -Url "deviceManagement/managedDevices/$DeviceID/deviceCategory/`$ref" -Content $body

}

$DeviceID = 'ADD-DEVICE-ID'
$DeviceCategory = 'ADD-THE-DEVICE-CATEGORY-ID'


Change-DeviceCategory -DeviceID $DeviceID -DeviceCategory $DeviceCategory