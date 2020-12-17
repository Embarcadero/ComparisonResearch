import { Time } from "@angular/common";

export interface Ifile {
    name: string,
    file: string, 
    size: number, 
    modified: Time, 
    isDirectory: boolean, 
    isFile: boolean
}
