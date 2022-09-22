

param workloadPoolVMSize string = 'standard_d2s_v3'
param workloadPoolAutoScale bool = true
param systemPoolVMSize string = 'standard_d2s_v3'
param kubernetesVersion string = '1.23.5'
param dnsPrefix string = 'aparna-ravindra-aks-dns'
param clusterName string
param aksAdminId string
param acrName string

var nodeResourceGroupName = '${resourceGroup().name}-kube'
param location string = 'eastus2'

module networking 'networking.bicep' = {
  name: 'networking'
  params: {
    aksName: '${resourceGroup().name}-virtual'
    location: location
  }
}

module aks 'aks.bicep' = {
  name: 'aks'
  params: {
    location: location
    nodeResourceGroupName: nodeResourceGroupName
    workloadPoolMaxCount: 3
    workloadPoolMinCount: 1
    workloadPoolAutoScale: workloadPoolAutoScale
    workloadPoolVMSize: workloadPoolVMSize
    systemPoolCount: 1
    systemPoolVMSize: systemPoolVMSize
    aksAdminId: aksAdminId
    dnsPrefix: dnsPrefix
    defaultSubnetId: networking.outputs.defaultSubnetId
    kubernetesVersion: kubernetesVersion
    acrName: acrName
    clusterName: clusterName
  }
}


output kubeletIdentityClientId string = aks.outputs.kubeletIdentityClientId
output kubeletIdentityObjectId string = aks.outputs.kubeletIdentityObjectId
output defaultSubnetId string = networking.outputs.defaultSubnetId
