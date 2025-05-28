import type { EffectFn1, EffectFn2, EffectFn4 } from "../../../../purescript.d.ts";

export const _writable: EffectFn1<
  { writable: WritableStream<Uint8Array<ArrayBufferLike>> },
  WritableStream<Uint8Array<ArrayBufferLike>>
> = (stream) => {
  return stream.writable;
};

export const _write: EffectFn4<
  { write: (data: Uint8Array) => Promise<number> },
  Uint8Array,
  EffectFn1<number, void>,
  EffectFn1<Error, void>,
  void
> = (stream, data, onSuccess, onError) => {
  stream.write(data)
    .then(onSuccess)
    .catch(onError);
};

export const _writeSync: EffectFn2<
  { writeSync: (data: Uint8Array) => number },
  Uint8Array,
  number
> = (stream, data) => {
  return stream.writeSync(data);
};

export const _close: EffectFn1<
  { close: () => void },
  void
> = (stream) => {
  return stream.close();
};
