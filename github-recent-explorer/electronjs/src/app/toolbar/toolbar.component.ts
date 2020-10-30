import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';

@Component({
    selector: 'app-toolbar',
    templateUrl: './toolbar.component.html',
    styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
    selectedDate: string = '';
    constructor(private _router: Router, public datepipe: DatePipe) {}

    doSelectionChange(event, value) {
        this._router.navigate(['/home'], { queryParams: { sort: value }, queryParamsHandling: "merge" });
    }

    doSelectDateChange(event, value) {
        this._router.navigate(['/home'], { queryParams: { created: this.datepipe.transform(value[0]._d, 'yyyy-MM-dd') }, queryParamsHandling: "merge" });
    }

    ngOnInit(){

    }
}