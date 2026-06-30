export const _close = (file) => {
    file.close();
};
export const _isTerminal = (file) => {
    return file.isTerminal();
};
export const _lock = (file, exclusive, onSuccess, onError) => {
    file.lock(exclusive)
        .then(onSuccess)
        .catch(onError);
};
export const _lockSync = (file, exclusive) => {
    file.lockSync(exclusive);
};
export const _read = (buffer, file, onSuccess, onError) => {
    file.read(buffer)
        .then(onSuccess)
        .catch(onError);
};
export const _readSync = (buffer, file) => {
    return file.readSync(buffer);
};
export const seekStart = Deno.SeekMode.Start;
export const seekCurrent = Deno.SeekMode.Current;
export const seekEnd = Deno.SeekMode.End;
export const _seek = (offset, whence, file, onSuccess, onError) => {
    file.seek(offset, whence)
        .then(onSuccess)
        .catch(onError);
};
export const _seekSync = (offset, whence, file) => {
    return file.seekSync(offset, whence);
};
export const _setRaw = (mode, options, file) => {
    file.setRaw(mode, options === null ? undefined : options);
};
export const _stat = (file, onSuccess, onError) => {
    file.stat()
        .then(onSuccess)
        .catch(onError);
};
export const _statSync = (file) => {
    return file.statSync();
};
export const _syncData = (file, onSuccess, onError) => {
    file.syncData()
        .then(onSuccess)
        .catch(onError);
};
export const _syncDataSync = (file) => {
    file.syncDataSync();
};
export const _syncSync = (file) => {
    file.syncSync();
};
export const _truncateSync = (size, file) => {
    file.truncateSync(size === null ? undefined : size);
};
export const _utime = (atime, mtime, file, onSuccess, onError) => {
    file.utime(atime, mtime)
        .then(onSuccess)
        .catch(onError);
};
export const _utimeSync = (atime, mtime, file) => {
    file.utimeSync(atime, mtime);
};
export const _write = (buffer, file, onSuccess, onError) => {
    file.write(buffer)
        .then(onSuccess)
        .catch(onError);
};
export const _writeSync = (buffer, file) => {
    return file.writeSync(buffer);
};
export const _sync = (file, onSuccess, onError) => {
    file.sync()
        .then(onSuccess)
        .catch(onError);
};
export const _truncate = (size, file, onSuccess, onError) => {
    file.truncate(size === null ? undefined : size)
        .then(onSuccess)
        .catch(onError);
};
export const _unlock = (file, onSuccess, onError) => {
    file.unlock()
        .then(onSuccess)
        .catch(onError);
};
export const _unlockSync = (file) => {
    file.unlockSync();
};
export const _readable = (file) => {
    return file.readable;
};
export const _writable = (file) => {
    return file.writable;
};
