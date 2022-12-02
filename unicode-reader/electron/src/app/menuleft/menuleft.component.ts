import { Component, OnInit, Input } from '@angular/core';
import { ComService } from '../com.service';
import { Menu } from '../menu';

@Component({
  selector: 'app-menuleft',
  templateUrl: './menuleft.component.html',
  styleUrls: ['./menuleft.component.css']
})
export class MenuleftComponent implements OnInit {
  _channelData: Array<any>;
  channels = [];
  menus = [];

  @Input() set channelData(value: Array<any>){
    console.log('menuleft channelData, ', value);
    this._channelData = value;
    for (let index = 0; index < this._channelData.length; index++) {
      const channel = this._channelData[index];
      this.menus.push(new Menu(channel.id, channel.title, '/home', 'Pascal', 'nav-icon fa fa-rss-square'));
    }   
  };

  get channelData() {
    return this._channelData;
  }

  constructor(public comSvc: ComService) { }

  ngOnInit (): void {
    
  }

}
