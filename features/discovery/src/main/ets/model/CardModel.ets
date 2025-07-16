import { BasicDataSource } from "datasource";

export class CardsSource extends BasicDataSource {
  private list: CardInfo[]

  constructor(list: CardInfo[]) {
    super();
    this.list = list
  }

  public totalCount(): number {
    return this.list.length;
  }

  public getData(index: number): CardInfo {
    return this.list[index]
  }
}

export interface CardInfo {
  id: string;
  title: string;
  introduce: string;
  singer: string;
  rating: number;
  price: string;
  img: string
}

export interface CardStateType {
  scale: number;
  rotate: number;
  zIndex: number;
  opacity: number;
  angle: number;
}

export interface PositionStateType {
  x: number;
  y: number;
}
