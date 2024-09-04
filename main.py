import concurrent.futures
import requests

# Define the API endpoint and subscription ID
api_endpoint = 'https://apim-sweden.azure-api.net/openai/deployments/gpt-35-turbo/chat/completions?api-version=2023-07-01-preview'
subscription_key = '66eadbd37d3a4dd2b45224bd3a77e5d6'

# Define the number of parallel requests and the total number of requests
batch_size = 20
total_requests = 1000  # Adjust as needed

# Function to make a single API request
def make_request(index):
    headers = {
        'api-key': subscription_key,
        'Content-Type': 'application/json',
        'Ocp-Apim-Trace': 'true'
    }
    payload = {
        "messages": [
            {
                "role": "user",
                "content": (
                    "I am writing a blog post for small business owners. "
                    "Provide an outline with 5 sections on 'Effective Marketing Strategies for Small Businesses'.\n\n"
                    "The outline should include an introduction and conclusion, and focus on the following topics:\n\n"
                    "- Understanding your target audience\n"
                    "- Content, social media, and email marketing strategies\n"
                    "- Measuring marketing success\n\n"
                    "The outline should clearly articulate the topic, and provide clear structure to ease reading for the target audience."
                )
            }
        ],
        "temperature": 1,
        "top_p": 1,
        "n": 1,
        "stream": False,
        "max_tokens": 5,
        "presence_penalty": 0,
        "frequency_penalty": 0,
        "logit_bias": {}
    }    
    response = requests.post(api_endpoint, headers=headers, json=payload)
    return index, response.status_code, response.headers["backend-host"]

# Function to run requests in batches
def run_batches():
    with concurrent.futures.ThreadPoolExecutor(max_workers=batch_size) as executor:
        for i in range(0, total_requests, batch_size):
            batch_indices = range(i, min(i + batch_size, total_requests))
            future_to_index = {executor.submit(make_request, index): index for index in batch_indices}
            for future in concurrent.futures.as_completed(future_to_index):
                index = future_to_index[future]
                try:
                    index, status_code, details = future.result()
                    print(f'Request {index}: Status Code: {status_code}, Details: {details}')
                except Exception as exc:
                    print(f'Request {index} generated an exception: {exc}')

if __name__ == '__main__':
    run_batches()