import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { SceditorComponent } from './sceditor/sceditor.component';

const routes: Routes = [
  { path: 'home', component: HomeComponent },
  { path: 'editor', component: SceditorComponent },
  { path: '', redirectTo: '/home', pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(
    routes, 
    {onSameUrlNavigation: 'reload'}
    )],
  exports: [RouterModule]
})
export class AppRoutingModule { }
