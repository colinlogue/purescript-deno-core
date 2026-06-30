export const empty = {};
export const append_ = (value) => ({
    append: value,
});
export const create = (value) => ({
    create: value,
});
export const createNew = (value) => ({
    createNew: value,
});
export const mode = (value) => ({
    mode: value,
});
export const combine = (a, b) => ({ ...a, ...b });
