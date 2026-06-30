// TypeScript foreign function implementations for Deno.DirEntry
export const _name = (dirEntry) => {
    return dirEntry.name;
};
export const _isFile = (dirEntry) => {
    return dirEntry.isFile;
};
export const _isDirectory = (dirEntry) => {
    return dirEntry.isDirectory;
};
export const _isSymlink = (dirEntry) => {
    return dirEntry.isSymlink;
};
