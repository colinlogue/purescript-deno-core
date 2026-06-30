export const recursive = (value) => ({
    recursive: value,
});
export const mode = (value) => ({
    mode: value,
});
export const empty = {};
export const combine = (a, b) => ({ ...a, ...b });
