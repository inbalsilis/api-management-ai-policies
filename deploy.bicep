var apimName = 'apim-ai-features'

var backendNames = [
  'aoai-wus-1'
  'aoai-eus-1'
  'aoai-eus-2'
]

var backendUrls = [
  'https://aoai-wus-1.openai.azure.com/openai'
  'https://aoai-eus-1.openai.azure.com/openai'
  'https://aoai-eus-2.openai.azure.com/openai'
]


resource apiManagementService 'Microsoft.ApiManagement/service@2023-09-01-preview' existing = {
  name: apimName
}

resource backends 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = [for (name, i) in backendNames: {
  name: name
  parent: apiManagementService
  properties: {
    url: backendUrls[i]
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
          name: '${name}BreakerRule'
          tripDuration: 'PT10S'
        }
      ]
    }
  }
}]

resource aoailbpool 'Microsoft.ApiManagement/service/backends@2023-09-01-preview' = {
  name: 'openaiopool'
  parent: apiManagementService
  properties: {
    description: 'Load balance openai instances'
    type: 'Pool'
    pool: {
      services: [
        {
          id: '/backends/${backendNames[0]}'
          priority: 1
        }
        {
          id: '/backends/${backendNames[1]}'
          priority: 2
          weight: 1
        }
        {
          id: '/backends/${backendNames[2]}'
          priority: 2
          weight: 3
        }
      ]
    }
  }
}
