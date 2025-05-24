import type { EffectFn1, EffectFn2 } from "../../purescript.d.ts";

export const _locked: EffectFn1<WritableStream<unknown>, boolean> = (stream) => {
  return stream.locked;
};

export const _abort: EffectFn2<
  string | null,
  WritableStream<unknown>,
  Promise<void>
> = (reason, stream) => {
  return stream.abort(reason === null ? undefined : reason);
};

export const _close: EffectFn1<WritableStream<unknown>, Promise<void>> = (stream) => {
  return stream.close();
};

export const _getWriter: EffectFn1<WritableStream<unknown>, WritableStreamDefaultWriter<unknown>> = (stream) => {
  return stream.getWriter();
};
