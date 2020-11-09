import { Component, OnInit } from '@angular/core';
import { Menu } from '../menu';

@Component({
  selector: 'app-menuleft',
  templateUrl: './menuleft.component.html',
  styleUrls: ['./menuleft.component.css']
})
export class MenuleftComponent implements OnInit {

  menus = [
    new Menu(1, 'Pascal', '/home', 'Pascal','nav-icon fas fa-code'),
    new Menu(2, 'Javascript', '/home', 'JavaScript', 'nav-icon fab fa-js'),
    new Menu(3, 'HTML', '/home', 'Pascal', 'nav-icon fab fa-html5'),
    new Menu(4, 'Java', '/home', 'Java', 'nav-icon fab fa-java'),
    new Menu(5, 'Python', '/home', 'Python', 'nav-icon fab fa-python'),
    new Menu(6, 'CSS', '/home', 'Pascal', 'nav-icon fab fa-css3'),
    new Menu(6, 'TypeScript', '/home', 'TypeScript', 'nav-icon fas fa-code'),
    new Menu(6, 'C#', '/home', 'C#', 'nav-icon fas fa-code'),
    new Menu(6, 'Ruby', '/home', 'Ruby', 'nav-icon fas fa-tachometer-alt'),
    new Menu(6, 'PHP', '/home', 'PHP', 'nav-icon fab fa-php'),
  ];

  constructor() { }

  ngOnInit(): void {
  }

}
