import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-housing',
  templateUrl: './housing.page.html',
  styleUrls: ['./housing.page.scss'],
})
export class HousingPage implements OnInit {

  constructor() { }

  ngOnInit() {
  }
  isModalOpen = false;

  setOpen(isOpen: boolean) {
    this.isModalOpen = isOpen;
  }
  public housingList = [
    {
      ville: 'Paris',
      loyer: 1200.50,
      credit: 250000,
      desc: 'Appartement spacieux avec vue sur la tour Eiffel',
      finCredit: new Date('2025-12-31')
    },
    {
      ville: 'Marseille',
      loyer: 800.75,
      credit: 180000,
      desc: 'Maison de ville avec jardin en plein centre',
      finCredit: new Date('2030-06-15')
    },
    {
      ville: 'Lyon',
      loyer: 950.00,
      credit: 220000,
      desc: 'Duplex moderne avec balcon',
      finCredit: new Date('2028-09-30')
    },
    {
      ville: 'Bordeaux',
      loyer: 700.25,
      credit: 150000,
      desc: 'Studio rénové proche des quais',
      finCredit: new Date('2032-02-28')
    },
    {
      ville: 'Nantes',
      loyer: 600.50,
      credit: 130000,
      desc: 'Appartement lumineux dans quartier calme',
      finCredit: new Date('2031-07-10')
    }
  ];
  
}
