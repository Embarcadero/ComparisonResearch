import { ChangeDetectorRef, Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'unicode-reader';
  _channels = Array<any>();
  set channels(value: Array<any>) {
    this._channels = value;
  };

  get channels(): Array<any> {
    return this._channels;
  }

  constructor(private cdr: ChangeDetectorRef) {}

  toolbarGetData(channels) {
    this.channels = channels;
    this.cdr.detectChanges();
  }

}
