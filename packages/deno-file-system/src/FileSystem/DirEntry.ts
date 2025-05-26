// TypeScript foreign function implementations for Deno.DirEntry

export const _name = (dirEntry: Deno.DirEntry): string => {
  return dirEntry.name;
};

export const _isFile = (dirEntry: Deno.DirEntry): boolean => {
  return dirEntry.isFile;
};

export const _isDirectory = (dirEntry: Deno.DirEntry): boolean => {
  return dirEntry.isDirectory;
};

export const _isSymlink = (dirEntry: Deno.DirEntry): boolean => {
  return dirEntry.isSymlink;
};
