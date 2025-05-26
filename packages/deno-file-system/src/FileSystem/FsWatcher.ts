import type { EffectFn1 } from "../../../../purescript";

export const _fsWatcherClose: EffectFn1<Deno.FsWatcher, void> = (watcher) => {
  watcher.close();
};

export const _fsEventKind: EffectFn1<Deno.FsEvent, string> = (event) => {
  return event.kind;
};

export const _fsEventFlag: EffectFn1<Deno.FsEvent, string | null> = (event) => {
  return event.flag || null;
};

export const _fsEventPaths: EffectFn1<Deno.FsEvent, string[]> = (event) => {
  return event.paths;
};
