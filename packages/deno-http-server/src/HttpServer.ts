import type { EffectFn1, EffectFn2, EffectFn3 } from "../../../purescript.d.ts";

// Serve function
export const _serve: EffectFn2<unknown, (req: Request) => Promise<Response>, Promise<void>> = 
  async (options, handler) => {
    return Deno.serve(options, handler).finished;
  };

// ServeTls function
export const _serveTls: EffectFn2<unknown, (req: Request) => Promise<Response>, Promise<void>> = 
  async (options, handler) => {
    return Deno.serveTls(options, handler).finished;
  };

// Server creation without starting
export const _createServer: EffectFn2<unknown, (req: Request) => Promise<Response>, unknown> = 
  (options, handler) => {
    return Deno.serve(options, handler);
  };

// Server creation with TLS without starting
export const _createServerTls: EffectFn2<unknown, (req: Request) => Promise<Response>, unknown> = 
  (options, handler) => {
    return Deno.serveTls(options, handler);
  };

// Server methods
export const _listenAndServe: EffectFn1<unknown, Promise<void>> = 
  async (server) => {
    return (server as Deno.Server).listenAndServe();
  };

export const _serverFinished: EffectFn1<unknown, Promise<void>> = 
  async (server) => {
    return (server as Deno.Server).finished;
  };

export const _closeServer: EffectFn1<unknown, Promise<void>> = 
  async (server) => {
    await (server as Deno.Server).close();
    return Promise.resolve();
  };