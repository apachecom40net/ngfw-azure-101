@description('Azure region for the VNet (defaults to the RG location).')
param location string = 'eastus'

@description('VNet name.')
param vnetName string = 'abc-server-vnet'

@description('VNet address space.')
param vnetCidr string = '192.168.1.0/24'

@description('Subnet CIDRs.')
param snetExternalCidr string = '192.168.1.0/27'
param snetInternalCidr string = '192.168.1.32/27'
param snetACidr string = '192.168.1.128/27'
param snetBCidr string = '192.168.1.160/27'

@description('Admin username for the Ubuntu VMs.')
param adminUsername string = 'azureuser'

@description('Admin password for the Ubuntu VMs.')
@secure()
param adminPassword string

@description('VM name for the instance in snet-a.')
param vmAName string = 'ubuntu-a'

@description('VM name for the instance in snet-b.')
param vmBName string = 'ubuntu-b'

module network './modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
    vnetName: vnetName
    vnetCidr: vnetCidr
    snetExternalCidr: snetExternalCidr
    snetInternalCidr: snetInternalCidr
    snetACidr: snetACidr
    snetBCidr: snetBCidr
  }
}

module vmA './modules/vm.bicep' = {
  name: 'vmA'
  params: {
    location: location
    vmName: vmAName
    subnetId: network.outputs.snetAId
    adminUsername: adminUsername
    adminPassword: adminPassword
    attachPublicIp: true
  }
}

module vmB './modules/vm.bicep' = {
  name: 'vmB'
  params: {
    location: location
    vmName: vmBName
    subnetId: network.outputs.snetBId
    adminUsername: adminUsername
    adminPassword: adminPassword
    attachPublicIp: true
  }
}

output vmAId string = vmA.outputs.vmId
output vmBId string = vmB.outputs.vmId
output vmAPublicIpId string = vmA.outputs.publicIpId
output vmBPublicIpId string = vmB.outputs.publicIpId
output vnetId string = network.outputs.vnetId
