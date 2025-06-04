export const _get = (env, key) => {
    return env.get(key) || null;
};
export const _set = (env, key, value) => {
    env.set(key, value);
};
export const _delete = (env, key) => {
    env.delete(key);
};
export const _has = (env, key) => {
    return env.has(key);
};
export const _toObject = (env) => {
    return env.toObject();
};
