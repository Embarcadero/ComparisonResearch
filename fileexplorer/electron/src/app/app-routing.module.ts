import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ListviewComponent } from './listview/listview.component';

const routes: Routes = [
  { path: 'listfile', component: ListviewComponent },
  { path: '', redirectTo: '/listfile', pathMatch: 'full'  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
