import type { EffectFn1, EffectFn2 } from "../purescript.d.ts";

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

export const _loadavg: EffectFn1<(min1: number) => (min5: number) => (min15: number) => unknown, unknown> = (constructor) => {
  const [min1, min5, min15] = Deno.loadavg();
  return constructor(min1)(min5)(min15);
};

export const _memoryUsage = () => {
  return Deno.memoryUsage();
};

export const osRelease = (): string => {
  return Deno.osRelease();
};

export const osUptime = (): number => {
  return Deno.osUptime();
};

export const _systemMemoryInfo = () => {
  return Deno.systemMemoryInfo();
};

export const _uid = (): number | null => {
  return Deno.uid();
};

export const _refTimer: EffectFn1<number, void> = (timerId) => {
  Deno.refTimer(timerId);
};

export const _unrefTimer: EffectFn1<number, void> = (timerId) => {
  Deno.unrefTimer(timerId);
};

export const _addSignalListener: EffectFn2<string, () => void, void> = (signal, handler) => {
  Deno.addSignalListener(signal as Deno.Signal, handler);
};

export const _removeSignalListener: EffectFn2<string, () => void, void> = (signal, handler) => {
  Deno.removeSignalListener(signal as Deno.Signal, handler);
};
