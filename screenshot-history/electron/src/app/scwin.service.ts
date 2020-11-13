import { EventEmitter, Injectable } from '@angular/core';
import { ComService } from './com.service';
import { Scwindow } from './scwindow';

interface ImageSize {
    height: number;
    width: number;
}

@Injectable({
    providedIn: 'root'
})

export class ScwinService {
    items: Array<Scwindow> = [];
    ChangeDataEvent = new EventEmitter<Scwindow[]>();
    selectedWindow: Scwindow;
    imageSize: ImageSize;
    ChangeSizeEvent = new EventEmitter();
    croping: boolean = false;


    constructor(private com: ComService) {
        this.com.on('getWindows', (event: Electron.IpcMessageEvent, scWins) => {
            this.clear();
            scWins.forEach(win => {
              this.addScWin(win);
            });
            this.NotifyNewWindow();
        });
    }

    requestGetWindow(scWindow: Scwindow): Scwindow {
        let  reqWindow = (ev: any) => this.com.sendSync('reqWindow', ev);
        return <any>reqWindow(scWindow.name);
    }

    setSelectedWindow(window: Scwindow): void {
        this.selectedWindow = this.requestGetWindow(window);
    }

    getSelectedWindow(): Scwindow {
        return this.selectedWindow;
    }

    NotifyNewWindow() {
        this.ChangeDataEvent.emit(this.items);
    }

    NotifyNewSize() {
        this.ChangeSizeEvent.emit();
    }

    addScWin(scWindow) {
        this.items.push(scWindow);
    }

    getItems() {
        return this.items;
    }

    clear() {
        this.items = [];
        return this.items;
    }

    newSize(imageSize: ImageSize) {
        this.imageSize= imageSize;
        this.NotifyNewSize();
    }

    startCrop(): void{
        this.croping = true;
    }
}
