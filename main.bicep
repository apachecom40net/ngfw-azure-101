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

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
    subnets: [
      {
        name: 'snet-external'
        properties: {
          addressPrefix: snetExternalCidr
        }
      }
      {
        name: 'snet-internal'
        properties: {
          addressPrefix: snetInternalCidr
        }
      }
      {
        name: 'snet-a'
        properties: {
          addressPrefix: snetACidr
        }
      }
      {
        name: 'snet-b'
        properties: {
          addressPrefix: snetBCidr
        }
      }
    ]
  }
}
