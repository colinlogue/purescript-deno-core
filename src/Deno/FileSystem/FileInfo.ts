// TypeScript foreign function implementations for Deno.FileInfo

// Basic file type properties

export const _isFile = (fileInfo: Deno.FileInfo): boolean => {
  return fileInfo.isFile;
};

export const _isDirectory = (fileInfo: Deno.FileInfo): boolean => {
  return fileInfo.isDirectory;
};

export const _isSymlink = (fileInfo: Deno.FileInfo): boolean => {
  return fileInfo.isSymlink;
};

// Size property

export const _size = (fileInfo: Deno.FileInfo): number => {
  return fileInfo.size;
};

// Time properties (nullable Date objects)

export const _mtime = (fileInfo: Deno.FileInfo): Date | null => {
  return fileInfo.mtime;
};

export const _atime = (fileInfo: Deno.FileInfo): Date | null => {
  return fileInfo.atime;
};

export const _birthtime = (fileInfo: Deno.FileInfo): Date | null => {
  return fileInfo.birthtime;
};

export const _ctime = (fileInfo: Deno.FileInfo): Date | null => {
  return fileInfo.ctime;
};

// File system properties

export const _dev = (fileInfo: Deno.FileInfo): number => {
  return fileInfo.dev;
};

export const _ino = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.ino;
};

export const _mode = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.mode;
};

export const _nlink = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.nlink;
};

export const _uid = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.uid;
};

export const _gid = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.gid;
};

export const _rdev = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.rdev;
};

export const _blksize = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.blksize;
};

export const _blocks = (fileInfo: Deno.FileInfo): number | null => {
  return fileInfo.blocks;
};

// Device type properties (nullable Boolean objects)

export const _isBlockDevice = (fileInfo: Deno.FileInfo): boolean | null => {
  return fileInfo.isBlockDevice;
};

export const _isCharDevice = (fileInfo: Deno.FileInfo): boolean | null => {
  return fileInfo.isCharDevice;
};

export const _isFifo = (fileInfo: Deno.FileInfo): boolean | null => {
  return fileInfo.isFifo;
};

export const _isSocket = (fileInfo: Deno.FileInfo): boolean | null => {
  return fileInfo.isSocket;
};
