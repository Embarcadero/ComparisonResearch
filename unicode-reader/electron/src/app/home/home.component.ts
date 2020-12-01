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
  constructor() { }

  ngOnInit(): void {
    
  }

}
