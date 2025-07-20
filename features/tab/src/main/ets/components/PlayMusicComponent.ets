import { playingMusicData, PlayingMusicData } from "datasource";

@ComponentV2
export struct PlayMusicComponent {
  @Local playingMusic: PlayingMusicData = playingMusicData

  build() {
    Row() {
      Text(this.playingMusic.title)

    }
    .height(100)
    .width('100%')
    .backgroundColor(Color.Pink)
    .borderRadius({ topLeft: 35, topRight: 35 })
    .margin({ bottom: -25 })
    .padding({ left: '5%', right: '5%' })
  }
}