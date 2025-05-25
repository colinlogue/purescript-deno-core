import type { EffectFn1, EffectFn2, EffectFn3 } from "../../purescript.d.ts";

export const _get: EffectFn2<Deno.Env, string, string | null> = (env: Deno.Env, key: string) => {
  return env.get(key) || null;
};

export const _set: EffectFn3<Deno.Env, string, string, void> = (env: Deno.Env, key: string, value: string) => {
  env.set(key, value);
};

export const _delete: EffectFn2<Deno.Env, string, void> = (env: Deno.Env, key: string) => {
  env.delete(key);
};

export const _has: EffectFn2<Deno.Env, string, boolean> = (env: Deno.Env, key: string) => {
  return env.has(key);
};

export const _toObject: EffectFn1<Deno.Env, Record<string, string>> = (env: Deno.Env) => {
  return env.toObject();
};
