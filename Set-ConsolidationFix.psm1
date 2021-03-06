Function Set-ConsolidationFix  {
<#
	.SYNOPSIS
	Set VM SnapShot Consolidation Timout Workaround
  
	.DESCRIPTION
	Set VM SnapShot Consolidation Timout Workaround

	.Example
	Set-ConsolidationFix -vCenterVM "myTest" -Fix "Timeout"

	.Example
	Set-ConsolidationFix -vCenterVM "myTest" -Fix "Stun"
	
	.Notes
	NAME:  Set-ConsolidationFix.ps1
	LASTEDIT: 08/24/2016
	VERSION: 1.1
	KEYWORDS: VMware, vSphere, ESXi, Workaround, Snapshot
   
	.Link
	http://mycloudrevolution.com/
 
 #Requires PS -Version 4.0
 #Requires -Modules VMware.VimAutomation.Core, @{ModuleName="VMware.VimAutomation.Core";ModuleVersion="6.3.0.0"}
 #>

	[cmdletbinding()]
	param (
	[parameter(Mandatory=$true)]
	[string]$vCenterVM,
	[parameter(Mandatory=$true)]
	[string]$Fix = "Timeout" # Timeout os Stun

	)
	Process {
		if (Get-VM $vCenterVM -ErrorAction SilentlyContinue) {
			if ($Fix -like "Timeout") {
				$myVM = Get-VM $vCenterVM 
				$MyVM | New-AdvancedSetting -Name snapshot.asyncConsolidate.forceSync -Value TRUE -Confirm:$False -Force:$True
				$MySnap = $MyVM | New-Snapshot -Name "ConsolidationFix" 
            	$MySnap | Remove-Snapshot -confirm:$false
			}
			elseif ($Fix -like "Stun") {
				$myVM = Get-VM $vCenterVM 
				$MyVM | New-AdvancedSetting -Name snapshot.maxConsolidateTime -Value 30 -Confirm:$False -Force:$True
				$MySnap = $MyVM | New-Snapshot -Name "ConsolidationFix" 
            	$MySnap | Remove-Snapshot -confirm:$false
			}
			else {
				Write-Error "No Valid Fix"
			}
		}
		else {
			Write-Error "VM not Found"
		}
	}
}