import { BasicDataSource } from "datasource";

export class CardsSource extends BasicDataSource {
  private list: CardInfo[] = [];

  constructor(list: CardInfo[]) {
    super();
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): CardInfo {
    return this.list[index];
  }

  getList(): CardInfo[] {
    return this.list
  }
}

export interface CardInfo {
  id: string,
  src: string
}