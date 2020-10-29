import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { SidenavComponent } from './sidenav/sidenav.component';
import { MenubarComponent } from './menubar/menubar.component';
import { MenuleftComponent } from './menuleft/menuleft.component';
import { HomeComponent } from './home/home.component';
import { ListviewComponent } from './listview/listview.component';
import { SortbyinputComponent } from './sortbyinput/sortbyinput.component';

@NgModule({
  declarations: [
    AppComponent,
    ToolbarComponent,
    SidenavComponent,
    MenubarComponent,
    MenuleftComponent,
    HomeComponent,
    ListviewComponent,
    SortbyinputComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FontAwesomeModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
