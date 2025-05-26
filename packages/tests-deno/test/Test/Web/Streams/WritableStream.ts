export const encodeText = (text: string): Uint8Array => {
  const encoder = new TextEncoder();
  return encoder.encode(text);
};
