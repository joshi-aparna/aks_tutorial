# aks_tutorial
Pre-requisite:

https://github.com/joshi-aparna/aks_tutorial/tree/start_here#readme

In the pre-requisite, we have created a web api application and ran steps to containerize it. We deployed it to AKS manually.

To deploy to AKS, we will now make use of Bicep templates. From [Microsoft docs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep), Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. Your resources are deployed in a consistent manner.

We use the [QuickStart](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep?tabs=azure-cli%2CCLI) in the Microsoft docs to get started.

1. Ensure you are logged into your azure subscription by running `az login`.
2. Ensure that your subscription of choice is set as default.
3. Ensure you have the `Bicep` VS Code extension

I used [this](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity) doc to create a user assigned managed identity. I will be setting its principal id as the aksAdmin in the next step. 

az deployment group create --resource-group aparna-ravindra-aks --template-file bicep/main.bicep --parameters clusterName=aks_tutorial acrName=aparnacr007 aksAdminId=179a0b82-30ab-4b6d-821c-7756255a5da8