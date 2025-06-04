export const dir = (value) => ({
    dir: value,
});
export const prefix = (value) => ({
    prefix: value,
});
export const suffix = (value) => ({
    suffix: value,
});
export const empty = {};
export const combine = (a, b) => ({ ...a, ...b });
