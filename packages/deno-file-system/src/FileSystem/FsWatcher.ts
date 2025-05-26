import type { EffectFn1, EffectFn2 } from "../../../../purescript";

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

export const _watch: EffectFn2<(event: Deno.FsEvent) => void, Deno.FsWatcher, () => void> = 
  (handler, watcher) => {
    // Create an AbortController to allow canceling the watch
    const abortController = new AbortController();
    const signal = abortController.signal;
    
    // Start the async iteration
    (async () => {
      try {
        // Only iterate while the signal is not aborted
        for await (const event of watcher) {
          if (signal.aborted) {
            break;
          }
          handler(event);
        }
      } catch (e) {
        if (!(e instanceof Error && e.name === "AbortError")) {
          console.error("Error in FsWatcher.watch:", e);
        }
      }
    })();
    
    // Return a function that will abort the iteration when called
    return () => {
      abortController.abort();
    };
  };
