export const stdoutIsTerminal = () => {
    return Deno.stdout.isTerminal();
};
