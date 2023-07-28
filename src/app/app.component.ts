import { Component } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
})
export class AppComponent {
  public appPages = [
    { title: 'Tableau de bord', url: '/dashboard', icon: 'apps' },
    { title: 'Mes logements', url: '/housing', icon: 'business' },
    { title: 'Mes locataires', url: '/auth', icon: 'accessibility' },
    { title: 'Mes contacts', url: '/auth', icon: 'briefcase' },
    { title: 'Paramettres', url: '/auth', icon: 'options' },
  ];

  constructor(private authService: AuthService) { }

  get user() {
    const user = this.authService.getCurrentUser();
    return user ? user : null;
  }

  logOut(){
    this.authService.signOut();
  }
}
