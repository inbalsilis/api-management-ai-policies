

# Azure API Management Circuit Breaker and Load Balancing with Azure OpenAI Service

Based on this aarticle: [Using Azure API Management Circuit Breaker and Load balancing with Azure OpenAI Service](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/using-azure-api-management-circuit-breaker-and-load-balancing/ba-p/4041003)


## Prerequisites





## Step I: Provision Azure API Management Backend Pool (bicep): 


Install or Upgrade Bicep CLI.
```bash
# az bicep install
az bicep upgrade
```

Login to Azure.
```bash
az login
```

Create a deployment at resource group from a remote template file, using parameters from a local JSON file.
```bash
az deployment group create --resource-group <resource-group-name> --template-file <path-to-your-bicep-file> --name apim-deployment
```
> **Note**: The following warning may be displayed when running the above command:
> ```bash
> /path/to/deploy.bicep(102,3) : Warning BCP035: The specified "object" declaration is missing the following required properties: "protocol", "url". If this is an inaccuracy in the documentation, please report it to the Bicep Team. [https://aka.ms/bicep-type-issues]
> ```

Output:
```json
{
  "id": "<deployment-id>",
  "location": null,
  "name": "apim-deployment",
  "properties": {
    "correlationId": "754b1f5b-323f-4d4d-99e0-7303d8f64695",
    .
    .
    .
    "provisioningState": "Succeeded",
    "templateHash": "8062591490292975426",
    "timestamp": "2024-09-07T06:54:37.490815+00:00",
  },
  "resourceGroup": "azure-apim",
  "type": "Microsoft.Resources/deployments"
}
```

![APIM Backends](/readme/apim-backends.png)


> **Note**: To view failed operations, filter operations with the 'Failed' state.
> ```bash
> az deployment operation group list --resource-group <resource-group-name> --name apim-deployment --query "[?properties.provisioningState=='Failed']"
> ```


## Step II: Create the API Management API
> **Note**: The following policy can be used in existing APIs or new APIs. the important part is to set the backend service to the backend pool created in the previous step.

### Option I: Add to existing API
All you need to do is to add the following load balancer policy to the existing API.
```xml
<set-backend-service id="lb-backend" backend-id="openaiopool" />
```
### Option II: Create new API
#### Add new API

1. Go to your API Management instance.
2. Click on APIs.
3. Click on Add API.
4. Select 'HTTP' API.
5. Giive it a name and set the URL suffix to 'openai'.

![APIM API](/readme/create-api.png)

#### Add "catch all" operation
1. Click on the API you just created.
2. Click on the 'Design' tab.
3. Click on Add operation.
4. Set the method to 'POST'.
5. Set the URL template to '/{*path}'.
6. Set the name.
7. Click on 'Save'.

![Add Operation](/readme/add-operation.png)

#### Add the Load Balancer Policy
1. Select the operation you just created.
2. Click on the 'Design' tab.
3. Click on 'Inbound processing' policy button '</>'.
4. Replace the existing policy with [this policy](/policy.xml)
5. Click on 'Save'.

> **Note**: The main policy is a load balancer policy that will distribute the requests to the backend pool created in the previous step.
> ```xml
> <set-backend-service id="lb-backend" backend-id="openaiopool" />
> ```

![Add Policy](/readme/policy.png)



## References


#### Azure API Management
[Backends in API Management](https://learn.microsoft.com/en-us/azure/api-management/backends?tabs=bicep)
[Microsoft.ApiManagement service/backends 2023-09-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/2023-09-01-preview/service/backends?pivots=deployment-language-bicep)
[Set backend service](https://learn.microsoft.com/en-us/azure/api-management/set-backend-service-policy)
[API Management policy expressions](https://learn.microsoft.com/en-us/azure/api-management/api-management-policy-expressions#ref-context-response)

#### az deployment group
[az deployment group](https://learn.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest)
[View deployment history with Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-history?tabs=azure-cli#deployment-operations-and-error-message)


#### Bicep
[Create parameters files for Bicep deployment](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files?tabs=Bicep)
[az bicep install](https://learn.microsoft.com/en-us/cli/azure/bicep?view=azure-cli-latest#az-bicep-install)
[az bicep upgrade](https://learn.microsoft.com/en-us/cli/azure/bicep?view=azure-cli-latest#az-bicep-upgrade)
[Microsoft.ApiManagement service/backends](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service/backends?pivots=deployment-language-bicep)
[Microsoft.ApiManagement service](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?pivots=deployment-language-bicep)
[az deployment group create](https://learn.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest#az-deployment-group-create)

#### Miscellaneous
[traceparent header](https://www.w3.org/TR/trace-context/#traceparent-header)
[Retry request ends with "Content length mismatch"](https://stackoverflow.com/questions/54648853/retry-request-ends-with-content-length-mismatch)