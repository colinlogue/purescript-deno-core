// TypeScript foreign function implementations for Deno.ChildProcess

export const pid = (childProcess: Deno.ChildProcess): number => {
  return childProcess.pid;
};
