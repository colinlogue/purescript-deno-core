export const _serveNet = (handler) => {
    return Deno.serve(handler);
};
export const _serveUnix = (transport, path, handler) => {
    const options = { path };
    if (transport) {
        options.transport = transport;
    }
    return Deno.serve(options, handler);
};
export const _serveVsock = (options, handler) => {
    return Deno.serve(options, handler);
};
export const _serveTcp = (options, handler) => {
    return Deno.serve(options, handler);
};
export const _finished = (server) => {
    return server.finished;
};
export const _addr = (server) => {
    return server.addr;
};
export const _ref = (server) => {
    server.ref();
};
export const _unref = (server) => {
    server.unref();
};
export const _shutdown = (server) => {
    return server.shutdown();
};
