import { Component, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'unicode-reader';
  channels: Array<any>;

  toolbarGetData(event) {
    this.channels = event;
    console.log('toolbarGetData: ', this.channels);
  }

}
