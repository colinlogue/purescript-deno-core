export const _mkdir = (opts, path, onSuccess, onError) => {
    Deno.mkdir(path, opts)
        .then(onSuccess)
        .catch(onError);
};
export const _readTextFile = (path, onSuccess, onError) => {
    Deno.readTextFile(path)
        .then(onSuccess)
        .catch(onError);
};
export const _writeTextFile = (opts, path, data, onSuccess, onError) => {
    Deno.writeTextFile(path, data, opts)
        .then(onSuccess)
        .catch(onError);
};
export const _open = (opts, path, onSuccess, onError) => {
    Deno.open(path, opts)
        .then(onSuccess)
        .catch(onError);
};
export const _chdir = (path) => {
    Deno.chdir(path);
};
export const _exit = (code) => {
    Deno.exit(code);
};
