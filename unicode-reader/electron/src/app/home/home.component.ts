import { Component, OnInit } from '@angular/core';
import { ComService } from '../com.service';

interface Channel {
  title: string,
  descriptiom: string,
  link: string
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  channels: Channel[];
  constructor(public comSvc: ComService) { }

  // getChannels(): Channel[] {
  //   let  resChannels: any[] = () => this.comSvc.sendSync('qryGetChannels');
  //   return resChannels;
  // }

  ngOnInit(): void {
    // this.channels = this.getChannels();
    console.log(this.comSvc.sendSync('qryGetChannels'));
  }

}
