export const stdoutIsTerminal = (): boolean => {
  return Deno.stdout.isTerminal();
};
