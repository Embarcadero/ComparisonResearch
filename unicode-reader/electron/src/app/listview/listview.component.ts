import { Component, Input, OnInit } from '@angular/core';
import { faStar, faAddressBook, faCheckSquare } from '@fortawesome/free-solid-svg-icons';
import { Repo } from '../models/repo';

@Component({
  selector: 'app-listview',
  templateUrl: './listview.component.html',
  styleUrls: ['./listview.component.css']
})
export class ListviewComponent implements OnInit {
  faStar = faStar;
  faAddressBook = faAddressBook;
  faCheckSquare = faCheckSquare;
  @Input() repos: Repo[];

  constructor() { }

  ngOnInit(): void {
  }

}
