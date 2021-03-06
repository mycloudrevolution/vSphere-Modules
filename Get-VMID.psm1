function Get-VMID {
<#	
    .NOTES
    ===========================================================================
    Created by: Markus Kraus
    Twitter: @VMarkus_K
    Private Blog: mycloudrevolution.com
    ===========================================================================
    Changelog:  
    2016.09 ver 1.0 Base Release 
    ===========================================================================
    External Code Sources:  
    http://www.lucd.info/2011/04/22/get-the-maximum-iops/
    ===========================================================================
    Tested Against Environment:
    vSphere Version: 5.5 U2
    PowerCLI Version: PowerCLI 6.3 R1, PowerCLI 6.5 R1
    PowerShell Version: 4.0, 5.0
    OS Version: Windows 8.1, Server 2012 R2
    ===========================================================================
    Keywords vSphere, ESXi, VM, vDisk
    ===========================================================================

    .DESCRIPTION
    This Function reports all VM IDs     

    .Example
    Get-VM -Name TST* | Get-VMID

	.Example
    Get-Folder -Name TST | Get-VM | Get-VMID | ft -AutoSize

#Requires PS -Version 4.0
#Requires -Modules VMware.VimAutomation.Core, @{ModuleName="VMware.VimAutomation.Core";ModuleVersion="6.3.0.0"}
#>

  [CmdletBinding()]
    param( 
        [Parameter(Mandatory=$true, ValueFromPipeline=$True, Position=0)]
        	[VMware.VimAutomation.ViCore.Impl.V1.Inventory.InventoryItemImpl[]]
        	$myVMs
    )
Process { 

	$MyView = @()
	ForEach ($myVM in $myVMs){
		$UUIDReport = [PSCustomObject] @{
				Name = $myVM.name 
				UUID = $myVM.extensiondata.Config.UUID
				InstanceUUID = $myVM.extensiondata.config.InstanceUUID
				LocationID = $myVM.extensiondata.config.LocationId
				MoRef = $myVM.extensiondata.Moref.Value
				}
		$MyView += $UUIDReport
		}
	$MyView
	}
}
