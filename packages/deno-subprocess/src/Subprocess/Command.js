export const _new = (opts, command) => {
    return new Deno.Command(command, opts);
};
export const _output = (command, onSuccess, onError) => {
    command.output()
        .then(onSuccess)
        .catch(onError);
};
export const _outputSync = (command) => command.outputSync();
export const _spawn = (command) => command.spawn();
