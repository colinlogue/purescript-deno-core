export const consoleSize = (): { columns: number; rows: number } => {
  return Deno.consoleSize();
};
