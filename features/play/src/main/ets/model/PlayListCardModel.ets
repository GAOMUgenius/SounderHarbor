export class CardsSource implements IDataSource {
  private list: CardInfo[] = [];

  constructor(list: CardInfo[]) {
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

  registerDataChangeListener(): void {
  }

  unregisterDataChangeListener(): void {
  }
}

export interface CardInfo {
  id: string,
  src: string
}