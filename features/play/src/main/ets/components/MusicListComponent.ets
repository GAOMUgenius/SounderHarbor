import { APPConstants, MusicData } from "datasource"

@ComponentV2
export struct MusicListComponent {
  @Local musicList: MusicData[] = []

  aboutToAppear(): void {
    this.musicList = APPConstants.MUSICLISTINFO
  }

  build() {
    // if(this.musicList.length)
  }
}