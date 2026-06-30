// Synchronous versions for Deno.FileSystem
export const _chmodSync = (path, mode) => {
    Deno.chmodSync(path, mode);
};
export const _chownSync = (path, uid, gid) => {
    Deno.chownSync(path, uid, gid);
};
export const _copyFileSync = (from, to) => {
    Deno.copyFileSync(from, to);
};
export const _createSync = (path) => {
    return Deno.createSync(path);
};
export const _linkSync = (oldPath, newPath) => {
    Deno.linkSync(oldPath, newPath);
};
export const _mkdirSync = (opts, path) => {
    Deno.mkdirSync(path, opts);
};
export const _openSync = (opts, path) => {
    return Deno.openSync(path, opts);
};
export const _readFileSync = (path) => {
    return Deno.readFileSync(path);
};
export const _readTextFileSync = (path) => {
    return Deno.readTextFileSync(path);
};
export const _removeSync = (path, recursive) => {
    Deno.removeSync(path, { recursive });
};
export const _renameSync = (oldPath, newPath) => {
    Deno.renameSync(oldPath, newPath);
};
export const _statSync = (path) => {
    return Deno.statSync(path);
};
export const _lstatSync = (path) => {
    return Deno.lstatSync(path);
};
export const _realPathSync = (path) => {
    return Deno.realPathSync(path);
};
export const _readLinkSync = (path) => {
    return Deno.readLinkSync(path);
};
export const _writeFileSync = (opts, path, data) => {
    Deno.writeFileSync(path, data, opts);
};
export const _writeTextFileSync = (opts, path, data) => {
    Deno.writeTextFileSync(path, data, opts);
};
export const _chmod = (path, mode, onSuccess, onError) => {
    Deno.chmod(path, mode)
        .then(onSuccess)
        .catch(onError);
};
export const _chown = (path, uid, gid, onSuccess, onError) => {
    Deno.chown(path, uid, gid)
        .then(onSuccess)
        .catch(onError);
};
export const _copyFile = (from, to, onSuccess, onError) => {
    Deno.copyFile(from, to)
        .then(onSuccess)
        .catch(onError);
};
export const _create = (path, onSuccess, onError) => {
    Deno.create(path)
        .then(onSuccess)
        .catch(onError);
};
export const _link = (oldPath, newPath, onSuccess, onError) => {
    Deno.link(oldPath, newPath)
        .then(onSuccess)
        .catch(onError);
};
export const _mkdir = (opts, path, onSuccess, onError) => {
    Deno.mkdir(path, opts)
        .then(onSuccess)
        .catch(onError);
};
export const _open = (opts, path, onSuccess, onError) => {
    Deno.open(path, opts)
        .then(onSuccess)
        .catch(onError);
};
export const _readTextFile = (path, onSuccess, onError) => {
    Deno.readTextFile(path)
        .then(onSuccess)
        .catch(onError);
};
export const _remove = (path, recursive, onSuccess, onError) => {
    Deno.remove(path, { recursive })
        .then(onSuccess)
        .catch(onError);
};
export const _rename = (oldPath, newPath, onSuccess, onError) => {
    Deno.rename(oldPath, newPath)
        .then(onSuccess)
        .catch(onError);
};
export const _symlink = (oldPath, newPath, type, onSuccess, onError) => {
    Deno.symlink(oldPath, newPath, type ? { type } : undefined)
        .then(onSuccess)
        .catch(onError);
};
export const _truncate = (path, len, onSuccess, onError) => {
    Deno.truncate(path, len === null ? undefined : len)
        .then(onSuccess)
        .catch(onError);
};
export const _umask = (mask) => {
    return Deno.umask(mask === null ? undefined : mask);
};
export const _writeTextFile = (opts, path, data, onSuccess, onError) => {
    Deno.writeTextFile(path, data, opts)
        .then(onSuccess)
        .catch(onError);
};
export const _readFile = (path, onSuccess, onError) => {
    Deno.readFile(path)
        .then(onSuccess)
        .catch(onError);
};
export const _writeFile = (opts, path, data, onSuccess, onError) => {
    Deno.writeFile(path, data, opts)
        .then(onSuccess)
        .catch(onError);
};
// Additional file system operations
export const _readDir = async (path, onSuccess, onError) => {
    try {
        const entries = [];
        for await (const entry of Deno.readDir(path)) {
            entries.push(entry);
        }
        onSuccess(entries);
    }
    catch (error) {
        onError(error);
    }
};
export const _stat = (path, onSuccess, onError) => {
    Deno.stat(path)
        .then(onSuccess)
        .catch(onError);
};
export const _lstat = (path, onSuccess, onError) => {
    Deno.lstat(path)
        .then(onSuccess)
        .catch(onError);
};
export const _realPath = (path, onSuccess, onError) => {
    Deno.realPath(path)
        .then(onSuccess)
        .catch(onError);
};
export const _readLink = (path, onSuccess, onError) => {
    Deno.readLink(path)
        .then(onSuccess)
        .catch(onError);
};
// DirEntry accessor functions
export const _dirEntryName = (entry) => {
    return entry.name;
};
export const _dirEntryIsFile = (entry) => {
    return entry.isFile;
};
export const _dirEntryIsDirectory = (entry) => {
    return entry.isDirectory;
};
export const _dirEntryIsSymlink = (entry) => {
    return entry.isSymlink;
};
// Temporary directory and file creation functions
export const _makeTempDir = (options, onSuccess, onError) => {
    Deno.makeTempDir(options)
        .then(onSuccess)
        .catch(onError);
};
export const _makeTempDirSync = (options) => {
    return Deno.makeTempDirSync(options);
};
export const _makeTempFile = (options, onSuccess, onError) => {
    Deno.makeTempFile(options)
        .then(onSuccess)
        .catch(onError);
};
export const _makeTempFileSync = (options) => {
    return Deno.makeTempFileSync(options);
};
// File time modification functions
export const _utime = (path, atime, mtime, onSuccess, onError) => {
    Deno.utime(path, atime, mtime)
        .then(onSuccess)
        .catch(onError);
};
export const _utimeSync = (path, atime, mtime) => {
    Deno.utimeSync(path, atime, mtime);
};
// File system watching functions
export const _watchFs = (paths, options) => {
    return Deno.watchFs(paths, options);
};
