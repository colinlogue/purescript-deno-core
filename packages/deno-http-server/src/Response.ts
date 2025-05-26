/// <reference lib="deno.ns" />

// Response utility functions

export const json = (data) => {
  return Response.json(data);
};

export const text = (content) => {
  return new Response(content, { 
    headers: { "Content-Type": "text/plain" } 
  });
};