@description('Azure region for the VNet (defaults to the RG location).')
param location string

@description('VNet name.')
param vnetName string

@description('VNet address space.')
param vnetCidr string

@description('Subnet CIDRs.')
param snetExternalCidr string
param snetInternalCidr string
param snetACidr string
param snetBCidr string

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

output vnetId string = vnet.id
output snetExternalId string = '${vnet.id}/subnets/snet-external'
output snetInternalId string = '${vnet.id}/subnets/snet-internal'
output snetAId string = '${vnet.id}/subnets/snet-a'
output snetBId string = '${vnet.id}/subnets/snet-b'
