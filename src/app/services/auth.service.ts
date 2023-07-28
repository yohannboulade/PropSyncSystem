import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import firebase from 'firebase/app';
import 'firebase/auth';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  user: firebase.User | null = null;
  private authReady: Promise<void>;

  constructor(private router:Router) { 
    // ajoutez votre configuration firebase ici
    const firebaseConfig = {
      apiKey: "AIzaSyAyD6Lji6eUlPqkT52_1rVAcNR3fwDbt0A",
      authDomain: "propsyncsystem.firebaseapp.com",
      projectId: "propsyncsystem",
      storageBucket: "propsyncsystem.appspot.com",
      messagingSenderId: "495256107684",
      appId: "1:495256107684:web:66b71c95efc8ccae514431"
    };
    // initialiser firebase
    if (!firebase.apps.length) {
      firebase.initializeApp(firebaseConfig);
    }

    // Créez une nouvelle promesse qui se résout lorsque l'état d'authentification est connu.
    this.authReady = new Promise((resolve, reject) => {
      firebase.auth().onAuthStateChanged((user) => {
        this.user = user;
        resolve();
      }, reject);
    });
  }

  // Méthode pour attendre que l'état d'authentification soit connu.
  async waitForAuthReady() {
    return this.authReady;
  }

  async getToken(): Promise<string | null> {
    const user = firebase.auth().currentUser;    
    return user ? await user.getIdToken() : null;
  }
  
  // fonction d'inscription
  async signUp(email: string, password: string) {
    await firebase.auth().createUserWithEmailAndPassword(email, password);
  }

  // fonction de connexion
  async signInWithEmailAndPassword(email: string, password: string) {
    await firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL);
    await firebase.auth().signInWithEmailAndPassword(email, password);
    // Rediriger vers le tableau de bord...
    this.router.navigateByUrl('/dashboard');
    }

  async signIn(email: string, password: string) {
    await firebase.auth().signInWithEmailAndPassword(email, password);
  }

  // fonction de déconnexion
  async signOut() {
    await firebase.auth().signOut();
  }

  // fonction pour obtenir l'utilisateur actuellement connecté
  getCurrentUser() {
    return firebase.auth().currentUser;
  }
}
