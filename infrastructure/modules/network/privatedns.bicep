param defaultDomain string
param ipAddress string

resource dns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name : defaultDomain
}

resource dnsEntry 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name : '${defaultDomain}/*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: ipAddress
      }
    ]
  }
}
