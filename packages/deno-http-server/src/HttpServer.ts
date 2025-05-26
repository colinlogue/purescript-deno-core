
import type { EffectFn1, EffectFn2, EffectFn3 } from "../../../purescript.d.ts";

export const _serveNet: EffectFn1<Deno.ServeHandler<Deno.NetAddr>, Deno.HttpServer<Deno.NetAddr>> = (handler) => {
  return Deno.serve(handler);
};

export const _serveUnix: EffectFn3<'unix' | null, string, Deno.ServeHandler<Deno.UnixAddr>, Deno.HttpServer<Deno.UnixAddr>> = (transport, path, handler) => {
  const options: Deno.ServeUnixOptions = { path };
  if (transport) {
    options.transport = transport;
  }
  return Deno.serve(options, handler);
};

export const _serveVsock: EffectFn2<Deno.ServeVsockOptions, Deno.ServeHandler<Deno.VsockAddr>, Deno.HttpServer<Deno.VsockAddr>> = (options, handler) => {
  return Deno.serve(options, handler);
};

export const _serveTcp: EffectFn2<Deno.ServeTcpOptions | (Deno.ServeTcpOptions & Deno.TlsCertifiedKeyPem), Deno.ServeHandler<Deno.NetAddr>, Deno.HttpServer<Deno.NetAddr>> = (options, handler) => {
  return Deno.serve(options, handler);
};
