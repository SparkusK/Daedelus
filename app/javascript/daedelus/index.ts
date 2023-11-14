import './polyfills.ts';

import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { DaedelusModule } from './app/app.module';


document.addEventListener('DOMContentLoaded', () => {
  platformBrowserDynamic().bootstrapModule(DaedelusModule);
});
