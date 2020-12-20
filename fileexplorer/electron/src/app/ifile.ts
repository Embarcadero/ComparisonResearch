import { Time } from "@angular/common";

export interface Ifile {
    
    path: string,
    name: string,
    size: number,
    extension: string,
    type: string
    children: []
    
}
