// TypeScript foreign function implementations for Deno.ChildProcess
import type { EffectFn1, EffectFn3 } from "../purescript.d.ts";

export const pid = (childProcess: Deno.ChildProcess): number => {
  return childProcess.pid;
};

export const _status: EffectFn3<
  Deno.ChildProcess,
  EffectFn1<{ success: boolean; code: number; signal: string | null }, void>,
  EffectFn1<Error, void>,
  void
> = (childProcess, onSuccess, onError) => {
  childProcess.status
    .then(onSuccess)
    .catch(onError);
};
