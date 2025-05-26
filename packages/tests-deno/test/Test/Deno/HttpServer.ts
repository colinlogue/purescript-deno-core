// HTTP Server test helper implementations
export function createResponse(text: string): Response {
  return new Response(text);
}

// Function to call server.shutdown() 
export function serverShutdown(server: any): void {
  server.shutdown();
}