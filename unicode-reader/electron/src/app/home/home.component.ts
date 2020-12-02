import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ComService } from '../com.service';

interface Article {
  title: string,
  descriptiom: string,
  link: string,
  is_read: boolean,
  timestamp: Date,
  channel: number
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  articles: Article[];
  constructor(public comSvc: ComService, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.route.queryParams
      .subscribe(params => {
        console.log(params);
        this.articles = this.comSvc.sendSync('qryGetArticles', params.channel);
        console.log('articles: ', this.articles);
      })
  }

}
