import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
    selector: 'app-toolbar',
    templateUrl: './toolbar.component.html',
    styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
    selectedDate: string = '';
    constructor(private _router: Router) {}

    doSelectionChange(event, value) {
        this._router.navigate(['/home'], { queryParams: { sort: value }, queryParamsHandling: "merge" });
    }

    doSelectDateChange(event, value) {
        console.log('value: ', value[0]._d);
    }

    ngOnInit(){

    }
}