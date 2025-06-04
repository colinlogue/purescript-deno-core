export const _netAddr = (transport, hostname, port) => {
    return {
        transport,
        hostname,
        port
    };
};
export const _unixAddr = (transport, path) => {
    return {
        transport,
        path,
    };
};
export const _vsockAddr = (cid, port) => {
    return {
        transport: 'vsock',
        cid,
        port
    };
};
export const _netAddrInfo = (addr, tcp, udp) => {
    return {
        transport: addr.transport === 'tcp' ? tcp : udp,
        hostname: addr.hostname,
        port: addr.port
    };
};
export const _unixAddrInfo = (addr, unix, unixpacket) => {
    return {
        transport: addr.transport === 'unix' ? unix : unixpacket,
        path: addr.path,
    };
};
export const _vsockAddrInfo = (addr, vsock) => {
    return {
        cid: addr.cid,
        port: addr.port,
    };
};
