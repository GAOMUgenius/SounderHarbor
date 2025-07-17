import { BasicDataSource } from 'datasource';

export class SwiperDataSource extends BasicDataSource {
  private list: string[] = [];

  constructor(list: string[]) {
    super();
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): string {
    return this.list[index];
  }
}