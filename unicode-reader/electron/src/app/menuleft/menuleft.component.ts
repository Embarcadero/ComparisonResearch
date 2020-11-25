import { Component, OnInit } from '@angular/core';
import { Menu } from '../menu';

@Component({
  selector: 'app-menuleft',
  templateUrl: './menuleft.component.html',
  styleUrls: ['./menuleft.component.css']
})
export class MenuleftComponent implements OnInit {

  menus = [
    new Menu(1, 'All Articles', '/home', 'Pascal','nav-icon fas fa-code'),
    new Menu(2, 'Subscriptions', '/home', 'JavaScript', 'nav-icon fab fa-js'),
    new Menu(3, 'Embarcadero English Blog', '/home', 'Pascal', 'nav-icon fab fa-html5'),
    new Menu(4, 'Embarcadero Japanese Blog', '/home', 'Java', 'nav-icon fab fa-java'),
    new Menu(5, 'Embarcadero German Blog', '/home', 'Python', 'nav-icon fab fa-python'),
    new Menu(6, 'Embarcadero Russion Blog', '/home', 'Pascal', 'nav-icon fab fa-css3'),
  ];

  constructor() { }

  ngOnInit(): void {
  }

}
