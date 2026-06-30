export const _chdir = (path) => {
    Deno.chdir(path);
};
export const cwd = () => {
    return Deno.cwd();
};
export const execPath = () => {
    return Deno.execPath();
};
export const _exit = (code) => {
    Deno.exit(code);
};
export const _gid = () => {
    return Deno.gid();
};
export const hostname = () => {
    return Deno.hostname();
};
export const _loadavg = (constructor) => {
    const [min1, min5, min15] = Deno.loadavg();
    return constructor(min1)(min5)(min15);
};
export const _memoryUsage = () => {
    return Deno.memoryUsage();
};
export const osRelease = () => {
    return Deno.osRelease();
};
export const osUptime = () => {
    return Deno.osUptime();
};
export const _systemMemoryInfo = () => {
    return Deno.systemMemoryInfo();
};
export const _uid = () => {
    return Deno.uid();
};
export const _refTimer = (timerId) => {
    Deno.refTimer(timerId);
};
export const _unrefTimer = (timerId) => {
    Deno.unrefTimer(timerId);
};
export const _addSignalListener = (signal, handler) => {
    Deno.addSignalListener(signal, handler);
};
export const _removeSignalListener = (signal, handler) => {
    Deno.removeSignalListener(signal, handler);
};
// Variables
export const args = Deno.args;
export const build = Deno.build;
export const env = Deno.env;
export const _getExitCode = () => {
    return Deno.exitCode;
};
export const _setExitCode = (code) => {
    Deno.exitCode = code;
};
export const mainModule = Deno.mainModule;
export const noColor = Deno.noColor;
export const pid = Deno.pid;
export const ppid = Deno.ppid;
export const version = Deno.version;
