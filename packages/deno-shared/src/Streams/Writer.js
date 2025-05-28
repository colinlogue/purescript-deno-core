export const _write = (writer, chunk, onSuccess, onError) => {
    writer.write(chunk)
        .then(onSuccess)
        .catch(onError);
};
export const _close = (writer, onSuccess, onError) => {
    writer.close()
        .then(onSuccess)
        .catch(onError);
};
export const _abort = (writer, reason, onSuccess, onError) => {
    writer.abort(reason === null ? undefined : reason)
        .then(onSuccess)
        .catch(onError);
};
export const _releaseLock = (writer) => {
    writer.releaseLock();
};
export const _closed = (writer, onSuccess, onError) => {
    writer.closed
        .then(onSuccess)
        .catch(onError);
};
export const _ready = (writer, onSuccess, onError) => {
    writer.ready
        .then(onSuccess)
        .catch(onError);
};
