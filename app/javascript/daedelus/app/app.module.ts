import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';

import { DaedelusComponent } from './app.component';

@NgModule({
  declarations: [
    DaedelusComponent
  ],
  imports: [
    BrowserModule, FormsModule
  ],
  providers: [],
  bootstrap: [DaedelusComponent]
})
export class DaedelusModule { }
