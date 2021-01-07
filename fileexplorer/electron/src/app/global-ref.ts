import { IGlobalRef } from './iglobal';

export abstract class GlobalRef {
    abstract get nativeGlobal(): IGlobalRef;
}
