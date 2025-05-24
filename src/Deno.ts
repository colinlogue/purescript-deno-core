import type { EffectFn1, EffectFn3, EffectFn4, EffectFn5 } from "./purescript.d.ts";


export const _mkdir: EffectFn4<Deno.MkdirOptions, string | URL, () => void, EffectFn1<Error, void>, void> = (opts, path, onSuccess, onError) => {
  Deno.mkdir(path, opts)
    .then(onSuccess)
    .catch(onError);
};

export const _readTextFile: EffectFn3<string, EffectFn1<string | URL, void>, EffectFn1<Error, void>, void> = (path, onSuccess, onError) => {
  Deno.readTextFile(path)
    .then(onSuccess)
    .catch(onError);
};

export const _writeTextFile: EffectFn5<Deno.WriteFileOptions, string | URL, string, () => void, EffectFn1<Error, void>, void> = (opts, path, data, onSuccess, onError) => {
  Deno.writeTextFile(path, data, opts)
    .then(onSuccess)
    .catch(onError);
};

export const _open: EffectFn4<Deno.OpenOptions, string | URL, EffectFn1<Deno.FsFile, void>, EffectFn1<Error, void>, void> = (opts, path, onSuccess, onError) => {
  Deno.open(path, opts)
    .then(onSuccess)
    .catch(onError);
}

export const _chdir: EffectFn1<string | URL, void> = (path) => {
  Deno.chdir(path);
};

export const _exit: EffectFn1<number, void> = (code) => {
  Deno.exit(code);
};

export const _chmod: EffectFn4<string | URL, number, () => void, EffectFn1<Error, void>, void> = (path, mode, onSuccess, onError) => {
  Deno.chmod(path, mode)
    .then(onSuccess)
    .catch(onError);
};

export const _chown: EffectFn5<string | URL, number | null, number | null, () => void, EffectFn1<Error, void>, void> = (
  path,
  uid,
  gid,
  onSuccess,
  onError
) => {
  Deno.chown(path, uid, gid)
    .then(onSuccess)
    .catch(onError);
};

export const consoleSize = (): { columns: number; rows: number } => {
  return Deno.consoleSize();
};

export const _copyFile: EffectFn4<string | URL, string | URL, () => void, EffectFn1<Error, void>, void> = (from, to, onSuccess, onError) => {
  Deno.copyFile(from, to)
    .then(onSuccess)
    .catch(onError);
};

export const _create: EffectFn3<string | URL, EffectFn1<Deno.FsFile, void>, EffectFn1<Error, void>, void> = (path, onSuccess, onError) => {
  Deno.create(path)
    .then(onSuccess)
    .catch(onError);
};