import { GlobalRef } from "./global-ref";
import { IGlobalRef } from "./iglobal";

export class BrowserGlobalRef extends GlobalRef {
    get nativeGlobal(): IGlobalRef {
        return window as IGlobalRef;
    }
}
