import { BasicDataSource } from "../datasource/BasicDataSource";
import { MusicData } from "./MusicDataModel";

export class PlayListSource extends BasicDataSource {
  private list: MusicData[] = [];

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

  notifyDataReload() {
    this.notifyDataReload();
  }
}