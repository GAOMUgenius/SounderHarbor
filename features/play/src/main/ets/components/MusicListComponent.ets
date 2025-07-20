import { APPConstants, MusicData } from "datasource"
import { MusicListSource } from "../model/MusicListSource"

@ComponentV2
export struct MusicListComponent {
  @Param @Require musicList: MusicData[]
  @Local musicListData: MusicListSource = new MusicListSource([])

  aboutToAppear(): void {
    this.musicListData = new MusicListSource(this.musicList)
  }

  build() {
    if (this.musicListData.totalCount() !== 0) {
      List() {
        LazyForEach(this.musicListData, (item: MusicData) => {
          ListItem() {
            MusicListItem({ musicData: item })
          }
        })
      }
      .alignSelf(ItemAlign.Start)
      .scrollBar(BarState.Off)
      .padding({ top: 10 })
      .height('100%')
      .width('100%')
    } else {
      Column() {
        Text('快去添加您喜欢的音乐吧！')
          .fontSize(25)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontColor($r('app.color.app_main_fontcolor'))
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
  }
}

@ComponentV2
struct MusicListItem {
  @Param @Require musicData: MusicData
  @Local itemBackGroundColor: string = '#00000000'

  build() {
    Row() {
      Image(this.musicData.img)
        .width(50)
        .height(50)
        .borderRadius(10)
      Column() {
        Text(this.musicData.title)
          .fontSize(20)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontColor($r('app.color.app_main_fontcolor'))
        Text(this.musicData.singer)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontSize(12)
          .margin({ top: 5 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10, top: 5 })
    }
    .backgroundColor(this.itemBackGroundColor)
    .width('100%')
    .padding({ top: 5, bottom: 5 })
    .onTouch((event) => {
      if (event) {
        if (event.type === TouchType.Down) {
          this.itemBackGroundColor = '#ffe2e2e2'
        } else if (event.type === TouchType.Up) {
          this.itemBackGroundColor = '#00000000'
        }
      }
    })
  }
}