// TypeScript foreign function implementations for Deno.FileInfo
// Basic file type properties
export const _isFile = (fileInfo) => {
    return fileInfo.isFile;
};
export const _isDirectory = (fileInfo) => {
    return fileInfo.isDirectory;
};
export const _isSymlink = (fileInfo) => {
    return fileInfo.isSymlink;
};
// Size property
export const _size = (fileInfo) => {
    return fileInfo.size;
};
// Time properties (nullable Date objects)
export const _mtime = (fileInfo) => {
    return fileInfo.mtime;
};
export const _atime = (fileInfo) => {
    return fileInfo.atime;
};
export const _birthtime = (fileInfo) => {
    return fileInfo.birthtime;
};
export const _ctime = (fileInfo) => {
    return fileInfo.ctime;
};
// File system properties
export const _dev = (fileInfo) => {
    return fileInfo.dev;
};
export const _ino = (fileInfo) => {
    return fileInfo.ino;
};
export const _mode = (fileInfo) => {
    return fileInfo.mode;
};
export const _nlink = (fileInfo) => {
    return fileInfo.nlink;
};
export const _uid = (fileInfo) => {
    return fileInfo.uid;
};
export const _gid = (fileInfo) => {
    return fileInfo.gid;
};
export const _rdev = (fileInfo) => {
    return fileInfo.rdev;
};
export const _blksize = (fileInfo) => {
    return fileInfo.blksize;
};
export const _blocks = (fileInfo) => {
    return fileInfo.blocks;
};
// Device type properties (nullable Boolean objects)
export const _isBlockDevice = (fileInfo) => {
    return fileInfo.isBlockDevice;
};
export const _isCharDevice = (fileInfo) => {
    return fileInfo.isCharDevice;
};
export const _isFifo = (fileInfo) => {
    return fileInfo.isFifo;
};
export const _isSocket = (fileInfo) => {
    return fileInfo.isSocket;
};
