import { Component, Input, OnInit, Output, EventEmitter } from '@angular/core';
import { Article } from '../article';

@Component({
  selector: 'app-listview',
  templateUrl: './listview.component.html',
  styleUrls: ['./listview.component.css']
})
export class ListviewComponent implements OnInit {

  @Input() articles: any[];
  @Output() selectedArticle = new EventEmitter<Article>();

  constructor() { }

  readArticle(article: Article) {
    this.selectedArticle.emit(article);
  }

  ngOnInit(): void {
  }

}
