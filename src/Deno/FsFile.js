export const _close = (file) => {
    file.close();
};
export const _lock = (file, exclusive, onSuccess, onError) => {
    file.lock(exclusive)
        .then(onSuccess)
        .catch(onError);
};
export const _unlock = (file, onSuccess, onError) => {
    file.unlock()
        .then(onSuccess)
        .catch(onError);
};
export const seekStart = Deno.SeekMode.Start;
export const seekCurrent = Deno.SeekMode.Current;
export const seekEnd = Deno.SeekMode.End;
export const _seek = (offset, whence, file, onSuccess, onError) => {
    file.seek(offset, whence)
        .then(onSuccess)
        .catch(onError);
};
export const _truncate = (size, file, onSuccess, onError) => {
    file.truncate(size ?? undefined)
        .then(onSuccess)
        .catch(onError);
};
