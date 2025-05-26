export const decodeText = (uint8Array) => {
    return new TextDecoder().decode(uint8Array);
};
export const setEnvVar = (name) => (value) => () => {
    Deno.env.set(name, value);
};
