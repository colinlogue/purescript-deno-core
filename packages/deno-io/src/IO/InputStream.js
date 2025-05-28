export const _readable = (stream) => {
    return stream.readable;
};
export const _read = (stream, data, onSuccess, onError) => {
    stream.read(data)
        .then(onSuccess)
        .catch(onError);
};
export const _readSync = (stream, data) => {
    return stream.readSync(data);
};
export const _close = (stream) => {
    return stream.close();
};
