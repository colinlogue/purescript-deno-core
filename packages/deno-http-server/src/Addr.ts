import { Fn2, Fn3 } from "../../../purescript";


export const _netAddr: Fn3<'tcp' | 'udp', string, number, Deno.NetAddr> = (transport, hostname, port) => {
  return {
    transport,
    hostname,
    port
  };
};

export const _unixAddr: Fn2<'unix' | 'unixpacket', string, Deno.UnixAddr> = (transport, path) => {
  return {
    transport,
    path,
  };
};

export const _vsockAddr: Fn2<number, number, Deno.VsockAddr> = (cid, port) => {
  return {
    transport: 'vsock',
    cid,
    port
  };
};

export const _netAddrInfo = <T>(addr: Deno.NetAddr, tcp: T, udp: T): { transport: T; hostname: string; port: number; } => {
  return {
    transport: addr.transport === 'tcp' ? tcp : udp,
    hostname: addr.hostname,
    port: addr.port
  };
};

export const _unixAddrInfo = <T>(addr: Deno.UnixAddr, unix: T, unixpacket: T): { transport: T; path: string; } => {
  return {
    transport: addr.transport === 'unix' ? unix : unixpacket,
    path: addr.path,
  };
};

export const _vsockAddrInfo = <T>(addr: Deno.VsockAddr, vsock: T): { cid: number; port: number; } => {
  return {
    cid: addr.cid,
    port: addr.port,
  };
};
