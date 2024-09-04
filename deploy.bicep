// Define the API Management service
resource apiManagementService 'Microsoft.ApiManagement/service@2023-09-01-preview' existing = {
  name: 'apim-sweden'  // Replace with your API Management service name
}

resource openaione 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  name: 'openaione'
  parent: apiManagementService
  properties: {
    url: 'https://openaione.openai.azure.com/openai'
    protocol: 'http'
    circuitBreaker: {
      rules: [
        {
          acceptRetryAfter: true
          failureCondition: {
            count: 1
            interval: 'PT10S'
            statusCodeRanges: [
              {
                min: 429
                max: 429
              }
              {
                min: 500
                max: 503
              }
            ]
          }
          name: 'openaioneBreakerRule'
          tripDuration: 'PT10S'
        }
      ]
    }
  }
}
resource openaitwo 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  name: 'openaitwo'
  parent: apiManagementService
  properties: {
    url: 'https://openaitwo2.openai.azure.com/openai'
    protocol: 'http'
    circuitBreaker: {
      rules: [
        {
          acceptRetryAfter: true
          failureCondition: {
            count: 1
            interval: 'PT10S'
            statusCodeRanges: [
              {
                min: 429
                max: 429
              }
              {
                min: 500
                max: 503
              }
            ]
          }
          name: 'openaitwoBreakerRule'
          tripDuration: 'PT10S'
        }
      ]
    }
  }
}
resource openaithree 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  name: 'openaithree'
  parent: apiManagementService
  properties: {
    url: 'https://openaithree.openai.azure.com/openai'
    protocol: 'http'
    circuitBreaker: {
      rules: [
        {
          acceptRetryAfter: true
          failureCondition: {
            count: 1
            interval: 'PT10S'
            statusCodeRanges: [
              {
                min: 429
                max: 429
              }
              {
                min: 500
                max: 503
              }
            ]
          }
          name: 'openaithreeBreakerRule'
          tripDuration: 'PT10S'
        }
      ]
    }
  }
}
resource aoailbpool 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  name: 'openaiopool'
  parent: apiManagementService
  properties: {
    description: 'Load balance openai instances'
    type: 'Pool'
    pool: {
      services: [
        {
          id: '/backends/openaione'
          priority: 1
        }
        {
          id: '/backends/openaitwo'
          priority: 2
          weight: 1
        }
        {
          id: '/backends/openaithree'
          priority: 2
          weight: 3
        }
      ]
    }
  }
}
