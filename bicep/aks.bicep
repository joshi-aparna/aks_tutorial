param dnsPrefix string
param workloadPoolMinCount int
param workloadPoolMaxCount int
param workloadPoolAutoScale bool
param workloadPoolVMSize string
param systemPoolCount int
param systemPoolVMSize string
param defaultSubnetId string
param aksAdminId string
param kubernetesVersion string
param nodeResourceGroupName string
param acrName string
param clusterName string

@description('Specifies the location for the aks resources.')
param location string = 'eastus2'

var azureKubernetesServiceRbacClusterAdminRole = 'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
var networkContributorRoleID = '4d97b98b-1d4f-4787-a291-c67834d212e7'
var acrPullRoleID = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource aks 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: clusterName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  properties: {
    nodeResourceGroup: nodeResourceGroupName
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'systempool'
        osDiskSizeGB: 0 // default
        count: systemPoolCount
        vmSize: systemPoolVMSize
        orchestratorVersion: kubernetesVersion
        osType: 'Linux'
        mode: 'System'
        enableFIPS: false
        vnetSubnetID: defaultSubnetId
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        availabilityZones: [ 
          '1'
          '2'
          '3'
        ]
      }
      {
        name: 'workloadpool'
        osDiskSizeGB: 0 // default
        count: workloadPoolMinCount
        minCount: workloadPoolMinCount
        maxCount: workloadPoolMaxCount
        enableAutoScaling: workloadPoolAutoScale
        vmSize: workloadPoolVMSize
        orchestratorVersion: kubernetesVersion
        osType: 'Linux'
        mode: 'User'
        enableFIPS: false
        vnetSubnetID: defaultSubnetId
        availabilityZones: [ 
          '1'
          '2'
          '3'
        ]
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    enableRBAC: true
    disableLocalAccounts: true
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    apiServerAccessProfile: {
      authorizedIPRanges: [] // empty means allow all
    }
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
      }
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Give all admins "Azure Kubernetes Service RBAC Cluster Admin", which allows running any kubectl command.
resource aksAdminRoleAssignments 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, aksAdminId, azureKubernetesServiceRbacClusterAdminRole)
  scope: aks
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureKubernetesServiceRbacClusterAdminRole)
    principalId: aksAdminId
  }
}

resource networkRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, networkContributorRoleID)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', networkContributorRoleID)
    principalId: aks.identity.principalId
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2019-12-01-preview' existing = {
  scope: resourceGroup()
  name: acrName
}

resource acrPull 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acr.id, acrPullRoleID)
  scope: acr
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleID)
    principalId: aks.identity.principalId
  }
}

output kubeletIdentityObjectId string = any(aks.properties.identityProfile.kubeletidentity).objectId
output kubeletIdentityClientId string = any(aks.properties.identityProfile.kubeletidentity).clientId
output clusterPrincipalId string = aks.identity.principalId
output secretProviderClientId string = aks.properties.addonProfiles.azureKeyvaultSecretsProvider.identity.clientId
