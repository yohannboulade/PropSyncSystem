import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss'],
})
export class RegisterComponent {
  email!: string;
  password!: string;

  constructor(private authService: AuthService) { }

  register() {
    this.authService.signUp(this.email, this.password).then(() => {
      // Rediriger l'utilisateur après l'inscription
    }).catch((error) => {
      // Gérer les erreurs
      console.log(error);
    });
  }
}
