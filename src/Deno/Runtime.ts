import type { EffectFn1 } from "../purescript.d.ts";

export const _chdir: EffectFn1<string | URL, void> = (path) => {
  Deno.chdir(path);
};

export const cwd = (): string => {
  return Deno.cwd();
};

export const execPath = (): string => {
  return Deno.execPath();
};

export const _exit: EffectFn1<number, void> = (code) => {
  Deno.exit(code);
};

export const _gid = (): number | null => {
  return Deno.gid();
};

export const hostname = (): string => {
  return Deno.hostname();
};

export const osRelease = (): string => {
  return Deno.osRelease();
};

export const osUptime = (): number => {
  return Deno.osUptime();
};

export const _uid = (): number | null => {
  return Deno.uid();
};

export const _unrefTimer: EffectFn1<number, void> = (timerId) => {
  Deno.unrefTimer(timerId);
};
