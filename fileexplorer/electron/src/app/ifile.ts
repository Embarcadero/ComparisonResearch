import { Time } from "@angular/common";

export interface Ifile {
    
    path: string,
    name: string,
    modified: number,
    size: number,
    extension: string,
    type: string,
    children: []
    
}
