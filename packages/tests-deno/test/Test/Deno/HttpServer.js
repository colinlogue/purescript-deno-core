// HTTP Server test helper implementations
export function createResponse(text) {
  return new Response(text);
}

// Function to call server.shutdown() 
export function serverShutdown(server) {
  server.shutdown();
}