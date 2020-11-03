import { Component, OnInit } from '@angular/core';
import { CapturerService } from './capturer.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'screenshot-history';

  constructor(private capturer: CapturerService) {
    this.capturer.on('pong', (event: Electron.IpcMessageEvent) => {
      console.log('pong');
    });

    this.capturer.send('ping');
  }

  ngOnInit(): void {
    // this.capturer.sendWindows();
  }
  
}
