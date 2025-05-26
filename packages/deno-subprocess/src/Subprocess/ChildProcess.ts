// TypeScript foreign function implementations for Deno.ChildProcess
import type { EffectFn1, EffectFn3 } from "../../../../purescript.d.ts";

export const pid = (childProcess: Deno.ChildProcess): number => {
  return childProcess.pid;
};

export const _status: EffectFn3<
  Deno.ChildProcess,
  EffectFn1<Deno.CommandStatus, void>,
  EffectFn1<Error, void>,
  void
> = (childProcess, onSuccess, onError) => {
  childProcess.status
    .then(onSuccess)
    .catch(onError);
};

export const _stdin = (childProcess: Deno.ChildProcess): WritableStream<Uint8Array> => {
  return childProcess.stdin;
};

export const _stdout = (childProcess: Deno.ChildProcess): ReadableStream<Uint8Array> => {
  return childProcess.stdout;
};

export const _stderr = (childProcess: Deno.ChildProcess): ReadableStream<Uint8Array> => {
  return childProcess.stderr;
};

export const _kill = (signal: Deno.Signal | null, childProcess: Deno.ChildProcess): void => {
  if (signal) {
    childProcess.kill(signal);
  } else {
    childProcess.kill();
  }
};

export const _output: EffectFn3<
  Deno.ChildProcess,
  EffectFn1<Deno.CommandOutput, void>,
  EffectFn1<Error, void>,
  void
> = (childProcess, onSuccess, onError) => {
  childProcess.output()
    .then(onSuccess)
    .catch(onError);
};

export const _ref: EffectFn1<Deno.ChildProcess, void> = (childProcess) => {
  childProcess.ref();
}

export const _unref: EffectFn1<Deno.ChildProcess, void> = (childProcess) => {
  childProcess.unref();
}
