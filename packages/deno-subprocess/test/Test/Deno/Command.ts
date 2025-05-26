export const decodeText = (uint8Array: Uint8Array): string => {
  return new TextDecoder().decode(uint8Array);
};

export const setEnvVar = (name: string) => (value: string) => (): void => {
  Deno.env.set(name, value);
};