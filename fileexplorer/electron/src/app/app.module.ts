import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { MenubarComponent } from './menubar/menubar.component';
import { AppComponent } from './app.component';
import { HxtreeviewComponent } from './hxtreeview/hxtreeview.component';
import { OnlydirPipe } from './onlydir';

@NgModule({
  declarations: [
    AppComponent,
    ToolbarComponent,
    MenubarComponent,
    HxtreeviewComponent,
    OnlydirPipe
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
  ],
  providers: [OnlydirPipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
