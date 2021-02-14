import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
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

  constructor(public comSvc: ComService, private route: ActivatedRoute, private cdr: ChangeDetectorRef) { }

  selectedArticle(article){
    this.article = article;
    this.content_encoded = this.article.content;
    this.cdr.detectChanges();
  }

  ngOnInit(): void {
    this.route.queryParams
      .subscribe(params => {
        console.log('home.component: ', params);
        this.articles = this.comSvc.sendSync('qryGetArticles', params.channel);
        console.log('home.component -> articles: ', this.articles);
        this.cdr.detectChanges();
      })
  }

}
