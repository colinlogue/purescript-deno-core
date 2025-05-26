// HTTP Server test helper implementations
export function createResponse(text: string): Response {
  return new Response(text);
}

// Function to get response status
export function getResponseStatus(response: Response): number {
  return response.status;
}