# aks_tutorial
Pre-requisite:

https://github.com/joshi-aparna/aks_tutorial/tree/start_here#readme

In the pre-requisite, we have created a web api application and ran steps to containerize it. Now we try to deploy it to Azure Kubernetes cluster.

### Push image to a container registry
Now that you have built a docker container image, you should make it available in a container registry that can be accessed by the Kubernetes cluster you will deploy on Azure. 


### Kubernetes resources
We add the deployment file required to run the application on Kubernetes. Ensure that you have the `Kubernetes` VS Code extension. This provides auto-complete feature that is very useful.

[!kubernetes_extension.mov](./images/kubernetes_extension.mov)

To deploy to AKS, we will make use of Bicep templates. From [Microsoft docs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep), Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. Your resources are deployed in a consistent manner.

We use the [QuickStart](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=CLI) in the Microsoft docs to get started.

1. Ensure you are logged into your azure subscription by running `az login`.
2. Ensure that your subscription of choice is set as default.
3. Ensure you have the `Bicep` VS Code extension