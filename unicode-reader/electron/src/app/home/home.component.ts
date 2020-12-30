import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ComService } from '../com.service';
import { Article } from '../article';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  articles: Article[];
  article: Article;
  content_encoded: string;

  constructor(public comSvc: ComService, private route: ActivatedRoute) { }

  selectedArticle(article){
    this.article = article;
    this.content_encoded = this.article.content_encoded;
  }

  ngOnInit(): void {
    this.route.queryParams
      .subscribe(params => {
        console.log(params);
        this.articles = this.comSvc.sendSync('qryGetArticles', params.channel);
        console.log('articles: ', this.articles);
      })
  }

}
