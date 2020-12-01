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

  ngOnInit(): void {
    this.channels = this.comSvc.sendSync('qryGetChannels');
    for (let index = 0; index < this.channels.length; index++) {
      const channel = this.channels[index];
      this.menus.push(new Menu(index + 1, channel.title, '/home', 'Pascal', 'nav-icon fas fa-code'));
    }
  }

}
