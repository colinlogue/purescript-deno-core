export const _locked = (stream) => {
    return stream.locked;
};
export const _abort = (stream, reason, onSuccess, onError) => {
    return stream.abort(reason === null ? undefined : reason)
        .then(onSuccess)
        .catch(onError);
};
export const _close = (stream) => {
    return stream.close();
};
export const _getWriter = (stream) => {
    return stream.getWriter();
};
