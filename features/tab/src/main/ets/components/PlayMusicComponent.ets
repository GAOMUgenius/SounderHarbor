import { APPConstants, PlayingMusicData } from "datasource";
import { AppStorageV2 } from "@kit.ArkUI";

@ComponentV2
export struct PlayMusicComponent {
  @Local playingMusic: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!

  build() {
    Row() {
      Stack() {
        Image(this.playingMusic.img)
          .size({
            width: 50,
            height: 50
          })
          .borderRadius(25)
          .border({
            width: 1,
            color: Color.White
          })

        Row()
          .width(10)
          .height(10)
          .borderRadius(5)
          .backgroundColor("#80c2ce")
      }

      Column() {
        Text(this.playingMusic.title)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontColor($r('app.color.app_main_fontcolor'))
          .fontSize(18)
          .width('100%')
          .textAlign(TextAlign.Start)
        Text(this.playingMusic.singer)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontColor($r('app.color.app_main_fontcolor'))
          .fontSize(12)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({
            top: 5
          })
      }
      .margin({ left: 15 })
      .height(50)
      .layoutWeight(1)

      Image($r('app.media.playing_like_ic_on'))
        .width(20)
        .height(20)
        .margin({ right: 15, top: 17.5 })


      Image($r('app.media.playing_card_zanting'))
        .width(35)
        .height(35)
        .padding(10)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .margin({ right: 20, top: 10 })

    }
    .height(100)
    .width('100%')
    .backgroundColor('#80c2ce')
    .borderRadius({ topLeft: 35, topRight: 35 })
    .margin({ bottom: -25 })
    .padding({ left: '5%', right: '5%', top: 15 })
    .alignItems(VerticalAlign.Top)
  }
}