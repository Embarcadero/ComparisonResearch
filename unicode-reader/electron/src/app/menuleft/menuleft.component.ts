import { Component, OnInit } from '@angular/core';
import { ComService } from '../com.service';
import { Menu } from '../menu';

@Component({
  selector: 'app-menuleft',
  templateUrl: './menuleft.component.html',
  styleUrls: ['./menuleft.component.css']
})
export class MenuleftComponent implements OnInit {

  channels = [];
  menus = [];

  constructor(public comSvc: ComService) { }

  ngAfterViewInit(): void {
    let comSvc = this.comSvc;
    let menus = this.menus;
    var refreshId = setInterval(function() {
      this.channels = comSvc.sendSync('qryGetChannels');
      console.log('this.channels: ', this.channels);
      if (this.channels.length > 0) {
        clearInterval(refreshId);
        for (let index = 0; index < this.channels.length; index++) {
          const channel = this.channels[index];
          menus.push(new Menu(channel.id, channel.title, '/home', 'Pascal', 'nav-icon fas fa-code'));
        }   
      }
    }, 3000);
  }

  ngOnInit (): void {
    
  }

}
