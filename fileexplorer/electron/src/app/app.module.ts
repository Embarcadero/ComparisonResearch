import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { MenubarComponent } from './menubar/menubar.component';
import { AppComponent } from './app.component';
import { HxtreeviewComponent } from './hxtreeview/hxtreeview.component';

@NgModule({
  declarations: [
    AppComponent,
    ToolbarComponent,
    MenubarComponent,
    HxtreeviewComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
