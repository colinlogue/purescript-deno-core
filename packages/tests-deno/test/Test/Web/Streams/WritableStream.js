export const encodeText = (text) => {
    const encoder = new TextEncoder();
    return encoder.encode(text);
};
