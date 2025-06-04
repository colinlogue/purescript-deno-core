export const _fsWatcherClose = (watcher) => {
    watcher.close();
};
export const _fsEventKind = (event) => {
    return event.kind;
};
export const _fsEventFlag = (event) => {
    return event.flag || null;
};
export const _fsEventPaths = (event) => {
    return event.paths;
};
export const _watch = (handler, watcher) => {
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
        }
        catch (e) {
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
