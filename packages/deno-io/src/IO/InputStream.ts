import type { EffectFn1, EffectFn2, EffectFn4 } from "../../../../purescript.d.ts";

export const _readable: EffectFn1<
  { readable: ReadableStream<Uint8Array> },
  ReadableStream<Uint8Array>
> = (stream) => {
  return stream.readable;
};

export const _read: EffectFn4<
  { read: (data: Uint8Array) => Promise<number | null> },
  Uint8Array,
  EffectFn1<number | null, void>,
  EffectFn1<Error, void>,
  void
> = (stream, data, onSuccess, onError) => {
  stream.read(data)
    .then(onSuccess)
    .catch(onError);
};

export const _readSync: EffectFn2<
  { readSync: (data: Uint8Array) => number | null },
  Uint8Array,
  number | null
> = (stream, data) => {
  return stream.readSync(data);
};

export const _close: EffectFn1<
  { close: () => void },
  void
> = (stream) => {
  return stream.close();
};
