// HTTP Server test helper implementations
export function createResponse(text) {
  return new Response(text);
}

// Function to get response status
export function getResponseStatus(response) {
  return response.status;
}