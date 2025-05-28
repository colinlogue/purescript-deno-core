export const empty = {};
export const args = (value) => ({
    args: value,
});
export const _cwd = (value) => ({
    cwd: value,
});
export const clearEnv = (value) => ({
    clearEnv: value,
});
export const _env = (value) => ({
    env: value,
});
export const uid = (value) => ({
    uid: value,
});
export const gid = (value) => ({
    gid: value,
});
export const _stdin = (value) => ({
    stdin: value,
});
export const _stdout = (value) => ({
    stdout: value,
});
export const _stderr = (value) => ({
    stderr: value,
});
export const windowsRawArguments = (value) => ({
    windowsRawArguments: value,
});
export const combine = (a, b) => ({ ...a, ...b });
