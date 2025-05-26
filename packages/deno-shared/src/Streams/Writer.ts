import type { EffectFn1, EffectFn3, EffectFn4 } from "../../../../purescript.d.ts";

export const _write: EffectFn4<
  WritableStreamDefaultWriter<unknown>,
  unknown,
  () => void,
  EffectFn1<Error, void>,
  void
> = (writer, chunk, onSuccess, onError) => {
  writer.write(chunk)
    .then(onSuccess)
    .catch(onError);
};

export const _close: EffectFn3<
  WritableStreamDefaultWriter<unknown>,
  () => void,
  EffectFn1<Error, void>,
  void
> = (writer, onSuccess, onError) => {
  writer.close()
    .then(onSuccess)
    .catch(onError);
};

export const _abort: EffectFn4<
  WritableStreamDefaultWriter<unknown>,
  string | null,
  () => void,
  EffectFn1<Error, void>,
  void
> = (writer, reason, onSuccess, onError) => {
  writer.abort(reason === null ? undefined : reason)
    .then(onSuccess)
    .catch(onError);
};

export const _releaseLock: EffectFn1<WritableStreamDefaultWriter<unknown>, void> = (writer) => {
  writer.releaseLock();
};

export const _closed: EffectFn3<
  WritableStreamDefaultWriter<unknown>,
  () => void,
  EffectFn1<Error, void>,
  void
> = (writer, onSuccess, onError) => {
  writer.closed
    .then(onSuccess)
    .catch(onError);
};

export const _ready: EffectFn3<
  WritableStreamDefaultWriter<unknown>,
  () => void,
  EffectFn1<Error, void>,
  void
> = (writer, onSuccess, onError) => {
  writer.ready
    .then(onSuccess)
    .catch(onError);
};
