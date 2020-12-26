import { Component, OnInit } from '@angular/core';
import { Ifile } from '../ifile';

@Component({
  selector: 'app-listview',
  templateUrl: './listview.component.html',
  styleUrls: ['./listview.component.css']
})
export class ListviewComponent implements OnInit {
  ifiles: Array<Ifile> = [
    {
      path: '/path/1',
      name: 'name1',
      modified: Date.parse('12/12/2020 9:00'),  
      size: 27,
      extension: '',
      type: 'directory',
      children: []
    },
    {
      path: '/path/2',
      name: 'name2',
      modified: Date.parse('12/12/2020 9:00'),  
      size: 27,
      extension: '',
      type: 'directory',
      children: []
    },
    {
      path: '/path/3',
      name: 'name3',
      modified: Date.parse('12/12/2020 9:00'),  
      size: 27,
      extension: '',
      type: 'directory',
      children: []
    },
    {
      path: '/path/4',
      name: 'name4',
      modified: Date.parse('12/12/2020 9:00'),  
      size: 27,
      extension: '',
      type: 'directory',
      children: [] 
    }
  ];


  constructor() { }

  ngOnInit(): void {
  }

}
