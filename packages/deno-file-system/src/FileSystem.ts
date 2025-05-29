// Synchronous versions for Deno.FileSystem
export const _chmodSync: EffectFn2<string | URL, number, void> = (path, mode) => {
  Deno.chmodSync(path, mode);
};

export const _chownSync: EffectFn3<string | URL, number | null, number | null, void> = (path, uid, gid) => {
  Deno.chownSync(path, uid, gid);
};

export const _copyFileSync: EffectFn2<string | URL, string | URL, void> = (from, to) => {
  Deno.copyFileSync(from, to);
};

export const _createSync: EffectFn1<string | URL, Deno.FsFile> = (path) => {
  return Deno.createSync(path);
};

export const _linkSync: EffectFn2<string, string, void> = (oldPath, newPath) => {
  Deno.linkSync(oldPath, newPath);
};

export const _mkdirSync: EffectFn2<Deno.MkdirOptions, string | URL, void> = (opts, path) => {
  Deno.mkdirSync(path, opts);
};

export const _openSync: EffectFn2<Deno.OpenOptions, string | URL, Deno.FsFile> = (opts, path) => {
  return Deno.openSync(path, opts);
};

export const _readFileSync: EffectFn1<string | URL, Uint8Array> = (path) => {
  return Deno.readFileSync(path);
};

export const _readTextFileSync: EffectFn1<string | URL, string> = (path) => {
  return Deno.readTextFileSync(path);
};

export const _removeSync: EffectFn2<string | URL, boolean, void> = (path, recursive) => {
  Deno.removeSync(path, { recursive });
};

export const _renameSync: EffectFn2<string | URL, string | URL, void> = (oldPath, newPath) => {
  Deno.renameSync(oldPath, newPath);
};

export const _statSync: EffectFn1<string | URL, Deno.FileInfo> = (path) => {
  return Deno.statSync(path);
};

export const _lstatSync: EffectFn1<string | URL, Deno.FileInfo> = (path) => {
  return Deno.lstatSync(path);
};

export const _realPathSync: EffectFn1<string | URL, string> = (path) => {
  return Deno.realPathSync(path);
};

export const _readLinkSync: EffectFn1<string | URL, string> = (path) => {
  return Deno.readLinkSync(path);
};

export const _writeFileSync: EffectFn3<Deno.WriteFileOptions, string | URL, Uint8Array, void> = (opts, path, data) => {
  Deno.writeFileSync(path, data, opts);
};

export const _writeTextFileSync: EffectFn3<Deno.WriteFileOptions, string | URL, string, void> = (opts, path, data) => {
  Deno.writeTextFileSync(path, data, opts);
};
import type {
  EffectFn1,
  EffectFn2,
  EffectFn3,
  EffectFn4,
  EffectFn5,
} from "../../../purescript.d.ts";

export const _chmod: EffectFn4<
  string | URL,
  number,
  () => void,
  EffectFn1<Error, void>,
  void
> = (path, mode, onSuccess, onError) => {
  Deno.chmod(path, mode)
    .then(onSuccess)
    .catch(onError);
};

export const _chown: EffectFn5<
  string | URL,
  number | null,
  number | null,
  () => void,
  EffectFn1<Error, void>,
  void
> = (
  path,
  uid,
  gid,
  onSuccess,
  onError,
) => {
  Deno.chown(path, uid, gid)
    .then(onSuccess)
    .catch(onError);
};

export const _copyFile: EffectFn4<
  string | URL,
  string | URL,
  () => void,
  EffectFn1<Error, void>,
  void
> = (from, to, onSuccess, onError) => {
  Deno.copyFile(from, to)
    .then(onSuccess)
    .catch(onError);
};

export const _create: EffectFn3<
  string | URL,
  EffectFn1<Deno.FsFile, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.create(path)
    .then(onSuccess)
    .catch(onError);
};

export const _link: EffectFn4<
  string,
  string,
  () => void,
  EffectFn1<Error, void>,
  void
> = (oldPath, newPath, onSuccess, onError) => {
  Deno.link(oldPath, newPath)
    .then(onSuccess)
    .catch(onError);
};

export const _mkdir: EffectFn4<
  Deno.MkdirOptions,
  string | URL,
  () => void,
  EffectFn1<Error, void>,
  void
> = (opts, path, onSuccess, onError) => {
  Deno.mkdir(path, opts)
    .then(onSuccess)
    .catch(onError);
};

export const _open: EffectFn4<
  Deno.OpenOptions,
  string | URL,
  EffectFn1<Deno.FsFile, void>,
  EffectFn1<Error, void>,
  void
> = (opts, path, onSuccess, onError) => {
  Deno.open(path, opts)
    .then(onSuccess)
    .catch(onError);
};

export const _readTextFile: EffectFn3<
  string,
  EffectFn1<string | URL, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.readTextFile(path)
    .then(onSuccess)
    .catch(onError);
};

export const _remove: EffectFn4<
  string | URL,
  boolean,
  () => void,
  EffectFn1<Error, void>,
  void
> = (path, recursive, onSuccess, onError) => {
  Deno.remove(path, { recursive })
    .then(onSuccess)
    .catch(onError);
};

export const _rename: EffectFn4<
  string | URL,
  string | URL,
  () => void,
  EffectFn1<Error, void>,
  void
> = (oldPath, newPath, onSuccess, onError) => {
  Deno.rename(oldPath, newPath)
    .then(onSuccess)
    .catch(onError);
};

export const _symlink: EffectFn5<
  string | URL,
  string | URL,
  "file" | "dir" | "junction" | null,
  () => void,
  EffectFn1<Error, void>,
  void
> = (oldPath, newPath, type, onSuccess, onError) => {
  Deno.symlink(oldPath, newPath, type ? { type } : undefined)
    .then(onSuccess)
    .catch(onError);
};

export const _truncate: EffectFn4<
  string,
  number | null,
  () => void,
  EffectFn1<Error, void>,
  void
> = (path, len, onSuccess, onError) => {
  Deno.truncate(path, len === null ? undefined : len)
    .then(onSuccess)
    .catch(onError);
};

export const _umask: EffectFn1<number | null, number> = (mask) => {
  return Deno.umask(mask === null ? undefined : mask);
};

export const _writeTextFile: EffectFn5<
  Deno.WriteFileOptions,
  string | URL,
  string,
  () => void,
  EffectFn1<Error, void>,
  void
> = (opts, path, data, onSuccess, onError) => {
  Deno.writeTextFile(path, data, opts)
    .then(onSuccess)
    .catch(onError);
};

export const _readFile: EffectFn3<
  string | URL,
  EffectFn1<Uint8Array, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.readFile(path)
    .then(onSuccess)
    .catch(onError);
};

export const _writeFile: EffectFn5<
  Deno.WriteFileOptions,
  string | URL,
  Uint8Array,
  () => void,
  EffectFn1<Error, void>,
  void
> = (opts, path, data, onSuccess, onError) => {
  Deno.writeFile(path, data, opts)
    .then(onSuccess)
    .catch(onError);
};

// Additional file system operations

export const _readDir: EffectFn3<
  string | URL,
  EffectFn1<Deno.DirEntry[], void>,
  EffectFn1<Error, void>,
  void
> = async (path, onSuccess, onError) => {
  try {
    const entries: Deno.DirEntry[] = [];
    for await (const entry of Deno.readDir(path)) {
      entries.push(entry);
    }
    onSuccess(entries);
  } catch (error) {
    onError(error as Error);
  }
};

export const _stat: EffectFn3<
  string | URL,
  EffectFn1<Deno.FileInfo, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.stat(path)
    .then(onSuccess)
    .catch(onError);
};

export const _lstat: EffectFn3<
  string | URL,
  EffectFn1<Deno.FileInfo, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.lstat(path)
    .then(onSuccess)
    .catch(onError);
};

export const _realPath: EffectFn3<
  string | URL,
  EffectFn1<string, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.realPath(path)
    .then(onSuccess)
    .catch(onError);
};

export const _readLink: EffectFn3<
  string | URL,
  EffectFn1<string, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.readLink(path)
    .then(onSuccess)
    .catch(onError);
};

// DirEntry accessor functions
export const _dirEntryName: EffectFn1<Deno.DirEntry, string> = (entry) => {
  return entry.name;
};

export const _dirEntryIsFile: EffectFn1<Deno.DirEntry, boolean> = (entry) => {
  return entry.isFile;
};

export const _dirEntryIsDirectory: EffectFn1<Deno.DirEntry, boolean> = (entry) => {
  return entry.isDirectory;
};

export const _dirEntryIsSymlink: EffectFn1<Deno.DirEntry, boolean> = (entry) => {
  return entry.isSymlink;
};

// Temporary directory and file creation functions
export const _makeTempDir: EffectFn3<
  Deno.MakeTempOptions,
  EffectFn1<string, void>,
  EffectFn1<Error, void>,
  void
> = (options, onSuccess, onError) => {
  Deno.makeTempDir(options)
    .then(onSuccess)
    .catch(onError);
};

export const _makeTempDirSync: EffectFn1<Deno.MakeTempOptions, string> = (options) => {
  return Deno.makeTempDirSync(options);
};

export const _makeTempFile: EffectFn3<
  Deno.MakeTempOptions,
  EffectFn1<string, void>,
  EffectFn1<Error, void>,
  void
> = (options, onSuccess, onError) => {
  Deno.makeTempFile(options)
    .then(onSuccess)
    .catch(onError);
};

export const _makeTempFileSync: EffectFn1<Deno.MakeTempOptions, string> = (options) => {
  return Deno.makeTempFileSync(options);
};

// File time modification functions
export const _utime: EffectFn5<
  string | URL,
  number,
  number,
  () => void,
  EffectFn1<Error, void>,
  void
> = (path, atime, mtime, onSuccess, onError) => {
  Deno.utime(path, atime, mtime)
    .then(onSuccess)
    .catch(onError);
};

export const _utimeSync: EffectFn3<string | URL, number, number, void> = (path, atime, mtime) => {
  Deno.utimeSync(path, atime, mtime);
};

// File system watching functions
export const _watchFs: EffectFn2<
  string | string[],
  { recursive: boolean },
  Deno.FsWatcher
> = (paths, options) => {
  return Deno.watchFs(paths, options);
};
