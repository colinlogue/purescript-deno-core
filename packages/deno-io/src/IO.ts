export const consoleSize = (): { columns: number; rows: number } => {
  return Deno.consoleSize();
};

export const stderr = Deno.stderr;

export const stdin = Deno.stdin;

export const stdout = Deno.stdout;
