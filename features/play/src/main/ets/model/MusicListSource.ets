import { BasicDataSource, MusicData } from "datasource";

export class MusicListSource extends BasicDataSource {
  private list: MusicData[] = []
  constructor(list: MusicData[]) {
    super();
    this.list = list;
  }
  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): MusicData {
    return this.list[index];
  }

  getList(): MusicData[] {
    return this.list
  }

}