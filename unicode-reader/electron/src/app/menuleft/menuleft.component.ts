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
    this.channels = this.comSvc.sendSync('qryGetChannels');
    console.log();
    for (let index = 0; index < this.channels.length; index++) {
      const channel = this.channels[index];
      this.menus.push(new Menu(channel.id, channel.title, '/home', 'Pascal', 'nav-icon fas fa-code'));
    }   
  }

  ngOnInit (): void {
    
  }

}
