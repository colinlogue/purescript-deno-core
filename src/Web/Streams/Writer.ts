import type { EffectFn1, EffectFn2 } from "../../purescript.d.ts";

export const write: EffectFn2<
  unknown,
  WritableStreamDefaultWriter<unknown>,
  Promise<void>
> = (chunk, writer) => {
  return writer.write(chunk);
};

export const close: EffectFn1<WritableStreamDefaultWriter<unknown>, Promise<void>> = (writer) => {
  return writer.close();
};

export const abort: EffectFn2<
  string | null,
  WritableStreamDefaultWriter<unknown>,
  Promise<void>
> = (reason, writer) => {
  return writer.abort(reason === null ? undefined : reason);
};

export const releaseLock: EffectFn1<WritableStreamDefaultWriter<unknown>, void> = (writer) => {
  writer.releaseLock();
};

export const closed: EffectFn1<WritableStreamDefaultWriter<unknown>, Promise<void>> = (writer) => {
  return writer.closed;
};

export const ready: EffectFn1<WritableStreamDefaultWriter<unknown>, Promise<void>> = (writer) => {
  return writer.ready;
};
