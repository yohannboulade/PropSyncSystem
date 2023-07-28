import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent {
  email!: string;
  password!: string;

  constructor(private authService: AuthService) { }

  signInWithEmailAndPassword() {
    this.authService.signInWithEmailAndPassword(this.email, this.password)
  }

  debugLogUser() {
    console.log(this.authService.getCurrentUser());
  }
  
}
