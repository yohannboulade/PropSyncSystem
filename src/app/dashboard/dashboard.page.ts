import { Component, OnInit, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.page.html',
  styleUrls: ['./dashboard.page.scss'],
})
export class DashboardPage implements OnInit, AfterViewInit {
  
  constructor() { }
  
  ngOnInit() {
  }
  
  @ViewChild('loyer', { static: false }) loyerRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('benef', { static: false }) benefRef!: ElementRef<HTMLCanvasElement>;
  
  ngAfterViewInit() {
    /* Graphique de répartition des loyer mensuel par bien immobilier */
    const loyer = this.loyerRef.nativeElement;
    const ctx = loyer.getContext('2d')!;
    const data = {
      labels: ['Label 1', 'Label 2', 'Label 3'],
      datasets: [{
        data: [10, 20, 30],
        backgroundColor: ['#ff6384', '#36a2eb', '#ffce56']
      }]
    };
    const options = {
      responsive: true,
      maintainAspectRatio: false
    };
    new Chart(ctx, {
      type: 'pie',
      data: data,
      options: options
    });
    /* Graphique de répartition des benef mensuel par bien immobilier */
    const benef = this.benefRef.nativeElement;
    const ctxBenef = benef.getContext('2d')!;
    const dataBenef = {
      labels: ['Label 1', 'Label 2', 'Label 3'],
      datasets: [{
        data: [20, 18, 25],
        backgroundColor: ['#ff6384', '#36a2eb', '#ffce56']
      }]
    };
    const optionsBenef = {
      responsive: true,
      maintainAspectRatio: false
    };
    new Chart(ctxBenef, {
      type: 'pie',
      data: dataBenef,
      options: optionsBenef
    });
  }
}
