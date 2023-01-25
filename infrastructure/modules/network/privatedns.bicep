param zone string
param ipAddress string

resource dns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name : zone
}

resource dnsEntry 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name : '${zone}/*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: ipAddress
      }
    ]
  }
}
