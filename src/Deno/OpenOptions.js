export const empty = {};
export const read = (value) => ({ read: value });
export const write = (value) => ({ write: value });
export const append_ = (value) => ({ append: value });
export const truncate = (value) => ({ truncate: value });
export const create = (value) => ({ create: value });
export const createNew = (value) => ({ createNew: value });
export const mode = (value) => ({ mode: value });
export const combine = (a, b) => ({ ...a, ...b });
