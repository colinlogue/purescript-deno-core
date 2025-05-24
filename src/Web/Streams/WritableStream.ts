import type { EffectFn1, EffectFn4 } from "../../purescript.d.ts";

export const _locked: EffectFn1<WritableStream<unknown>, boolean> = (stream) => {
  return stream.locked;
};

export const _abort: EffectFn4<
  WritableStream<unknown>,
  string | null,
  () => void,
  EffectFn1<Error, void>,
  Promise<void>
> = (stream, reason, onSuccess, onError) => {
  return stream.abort(reason === null ? undefined : reason)
    .then(onSuccess)
    .catch(onError);
};

export const _close: EffectFn1<WritableStream<unknown>, Promise<void>> = (stream) => {
  return stream.close();
};

export const _getWriter: EffectFn1<WritableStream<unknown>, WritableStreamDefaultWriter<unknown>> = (stream) => {
  return stream.getWriter();
};
