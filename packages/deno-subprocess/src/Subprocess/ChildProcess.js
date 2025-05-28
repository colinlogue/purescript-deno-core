export const pid = (childProcess) => {
    return childProcess.pid;
};
export const _status = (childProcess, onSuccess, onError) => {
    childProcess.status
        .then(onSuccess)
        .catch(onError);
};
export const _stdin = (childProcess) => {
    return childProcess.stdin;
};
export const _stdout = (childProcess) => {
    return childProcess.stdout;
};
export const _stderr = (childProcess) => {
    return childProcess.stderr;
};
export const _kill = (signal, childProcess) => {
    if (signal) {
        childProcess.kill(signal);
    }
    else {
        childProcess.kill();
    }
};
export const _output = (childProcess, onSuccess, onError) => {
    childProcess.output()
        .then(onSuccess)
        .catch(onError);
};
export const _ref = (childProcess) => {
    childProcess.ref();
};
export const _unref = (childProcess) => {
    childProcess.unref();
};
