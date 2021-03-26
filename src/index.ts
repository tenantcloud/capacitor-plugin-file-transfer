import { registerPlugin } from "@capacitor/core";
import type { FileTransferPlugin } from "./definitions";

const FileTransfer = registerPlugin<FileTransferPlugin>("FileTransfer");

export * from "./definitions";
export { FileTransfer };