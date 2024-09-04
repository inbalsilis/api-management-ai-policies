

# Azure API Management Circuit Breaker and Load Balancing with Azure OpenAI Service

Based on this aarticle: [Using Azure API Management Circuit Breaker and Load balancing with Azure OpenAI Service](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/using-azure-api-management-circuit-breaker-and-load-balancing/ba-p/4041003)


Upgrade Bicep CLI.
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
> Note: The following warning may be displayed when running the pool deployment:
> ```bash
> /path/to/deploy.bicep(102,3) : Warning BCP035: The specified "object" declaration is missing the following required properties: "protocol", "url". If this is an inaccuracy in the documentation, please report it to the Bicep Team. [https://aka.ms/bicep-type-issues]
> ```

Output:
```json
{
  "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Resources/deployments/apim-deployment",
  "location": null,
  "name": "apim-deployment",
  "properties": {
    "correlationId": "<correlation-id>",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT4.4711162S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ApiManagement/service/apim-sweden/backends/openaione",
        "resourceGroup": "<resource-group-name>"
      },
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ApiManagement/service/apim-sweden/backends/openaiopool",
        "resourceGroup": "<resource-group-name>"
      },
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ApiManagement/service/apim-sweden/backends/openaithree",
        "resourceGroup": "<resource-group-name>"
      },
      {
        "id": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ApiManagement/service/apim-sweden/backends/openaitwo",
        "resourceGroup": "<resource-group-name>"
      }
    ],
    "outputs": null,
    "parameters": null,
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.ApiManagement",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              null
            ],
            "properties": null,
            "resourceType": "service/backends",
            "zoneMappings": null
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "4999696065877160403",
    "templateLink": null,
    "timestamp": "2024-09-04T01:26:14.822585+00:00",
    "validatedResources": null
  },
  "resourceGroup": "<resource-group-name>",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```



To view failed operations, filter operations with Failed state.
```bash
az deployment operation group list --resource-group <resource-group-name> --name ExampleDeployment --name apim-deployment --query "[?properties.provisioningState=='Failed']"
```





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
[az bicep upgrade](https://learn.microsoft.com/en-us/cli/azure/bicep?view=azure-cli-latest#az-bicep-upgrade)
[Microsoft.ApiManagement service/backends](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service/backends?pivots=deployment-language-bicep)
[Microsoft.ApiManagement service](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?pivots=deployment-language-bicep)

#### Miscellaneous
[traceparent header](https://www.w3.org/TR/trace-context/#traceparent-header)
[Retry request ends with "Content length mismatch"](https://stackoverflow.com/questions/54648853/retry-request-ends-with-content-length-mismatch)