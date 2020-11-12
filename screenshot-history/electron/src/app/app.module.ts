import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { SceditorComponent } from './sceditor/sceditor.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { CanvasmainComponent } from './canvasmain/canvasmain.component';


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    SceditorComponent,
    ToolbarComponent,
    CanvasmainComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
