export const _writable = (stream) => {
    return stream.writable;
};
export const _write = (stream, data, onSuccess, onError) => {
    stream.write(data)
        .then(onSuccess)
        .catch(onError);
};
export const _writeSync = (stream, data) => {
    return stream.writeSync(data);
};
export const _close = (stream) => {
    return stream.close();
};
