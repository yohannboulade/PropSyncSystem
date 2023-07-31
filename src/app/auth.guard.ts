import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AngularFireAuth } from '@angular/fire/auth';
import { take, map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(private afAuth: AngularFireAuth, private router: Router) {}

  canActivate(): Observable<boolean> {
    return this.afAuth.idToken.pipe(
      take(1),
      map(idToken => {
        if (!idToken) {
          this.router.navigate(['/auth/login']);
          return false;
        } else {
          return true;
        }
      })
    );
  }
}
