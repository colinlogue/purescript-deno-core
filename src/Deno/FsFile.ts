import type {
  EffectFn1,
  EffectFn2,
  EffectFn3,
  EffectFn4,
  EffectFn5,
} from "../purescript.d.ts";

export const _close: EffectFn1<Deno.FsFile, void> = (file) => {
  file.close();
};

export const _isTerminal: EffectFn1<Deno.FsFile, boolean> = (file) => {
  return file.isTerminal();
};

export const _lock: EffectFn4<
  Deno.FsFile,
  boolean,
  () => void,
  EffectFn1<Error, void>,
  void
> = (file, exclusive, onSuccess, onError) => {
  file.lock(exclusive)
    .then(onSuccess)
    .catch(onError);
};

export const _lockSync: EffectFn2<Deno.FsFile, boolean, void> = (file, exclusive) => {
  file.lockSync(exclusive);
};

export const _read: EffectFn4<
  Uint8Array,
  Deno.FsFile,
  EffectFn1<number | null, void>,
  EffectFn1<Error, void>,
  void
> = (buffer, file, onSuccess, onError) => {
  file.read(buffer)
    .then(onSuccess)
    .catch(onError);
};

export const _readSync: EffectFn2<Uint8Array, Deno.FsFile, number | null> = (buffer, file) => {
  return file.readSync(buffer);
};

export const seekStart: Deno.SeekMode = Deno.SeekMode.Start;

export const seekCurrent: Deno.SeekMode = Deno.SeekMode.Current;

export const seekEnd: Deno.SeekMode = Deno.SeekMode.End;

export const _seek: EffectFn5<
  number,
  Deno.SeekMode,
  Deno.FsFile,
  () => void,
  EffectFn1<Error, void>,
  void
> = (offset, whence, file, onSuccess, onError) => {
  file.seek(offset, whence)
    .then(onSuccess)
    .catch(onError);
};

export const _seekSync: EffectFn3<number, Deno.SeekMode, Deno.FsFile, number> = (offset, whence, file) => {
  return file.seekSync(offset, whence);
};

export const _setRaw: EffectFn3<boolean, Deno.SetRawOptions | null, Deno.FsFile, void> = (mode, options, file) => {
  file.setRaw(mode, options === null ? undefined : options);
};

export const _stat: EffectFn3<
  Deno.FsFile,
  EffectFn1<Deno.FileInfo, void>,
  EffectFn1<Error, void>,
  void
> = (file, onSuccess, onError) => {
  file.stat()
    .then(onSuccess)
    .catch(onError);
};

export const _statSync: EffectFn1<Deno.FsFile, Deno.FileInfo> = (file) => {
  return file.statSync();
};

export const _syncData: EffectFn3<
  Deno.FsFile,
  () => void,
  EffectFn1<Error, void>,
  void
> = (file, onSuccess, onError) => {
  file.syncData()
    .then(onSuccess)
    .catch(onError);
};

export const _syncDataSync: EffectFn1<Deno.FsFile, void> = (file) => {
  file.syncDataSync();
};

export const _syncSync: EffectFn1<Deno.FsFile, void> = (file) => {
  file.syncSync();
};

export const _truncateSync: EffectFn2<number | null, Deno.FsFile, void> = (size, file) => {
  file.truncateSync(size === null ? undefined : size);
};

export const _utime: EffectFn5<
  number,
  number,
  Deno.FsFile,
  () => void,
  EffectFn1<Error, void>,
  void
> = (atime, mtime, file, onSuccess, onError) => {
  file.utime(atime, mtime)
    .then(onSuccess)
    .catch(onError);
};

export const _utimeSync: EffectFn3<number, number, Deno.FsFile, void> = (atime, mtime, file) => {
  file.utimeSync(atime, mtime);
};

export const _write: EffectFn4<
  Uint8Array,
  Deno.FsFile,
  EffectFn1<number, void>,
  EffectFn1<Error, void>,
  void
> = (buffer, file, onSuccess, onError) => {
  file.write(buffer)
    .then(onSuccess)
    .catch(onError);
};

export const _writeSync: EffectFn2<Uint8Array, Deno.FsFile, number> = (buffer, file) => {
  return file.writeSync(buffer);
};

export const _sync: EffectFn3<
  Deno.FsFile,
  () => void,
  EffectFn1<Error, void>,
  void
> = (file, onSuccess, onError) => {
  file.sync()
    .then(onSuccess)
    .catch(onError);
};

export const _truncate: EffectFn4<
  number | null,
  Deno.FsFile,
  () => void,
  EffectFn1<Error, void>,
  void
> = (size, file, onSuccess, onError) => {
  file.truncate(size === null ? undefined : size)
    .then(onSuccess)
    .catch(onError);
};

export const _unlock: EffectFn3<
  Deno.FsFile,
  () => void,
  EffectFn1<Error, void>,
  void
> = (file, onSuccess, onError) => {
  file.unlock()
    .then(onSuccess)
    .catch(onError);
};

export const _unlockSync: EffectFn1<Deno.FsFile, void> = (file) => {
  file.unlockSync();
};

export const _readable: EffectFn1<Deno.FsFile, ReadableStream<Uint8Array>> = (file) => {
  return file.readable;
};

export const _writable: EffectFn1<Deno.FsFile, WritableStream<Uint8Array>> = (file) => {
  return file.writable;
};
