import { Component, OnInit } from '@angular/core';
import { ComService } from './com.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'screenshot-history';

  constructor(private com: ComService) {
    this.com.on('pongFromElectron', (event: Electron.IpcMessageEvent) => {
      console.log('pongFromElectron.. ', event);
    });

    // this.com.send('pingFromNg', 'test');
  }


  ngOnInit(): void {

  }
  
}
