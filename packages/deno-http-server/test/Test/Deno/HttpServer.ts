/// <reference lib="deno.ns" />

// Mock implementation for tests
export const mockRequest = () => {
  return new Request("http://localhost/test");
};

export const mockResponse = () => {
  return new Response("Test response");
};

export const fakeAbortSignal = () => {
  const controller = new AbortController();
  return controller.signal;
};