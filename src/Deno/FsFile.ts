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
