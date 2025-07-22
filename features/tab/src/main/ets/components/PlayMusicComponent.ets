import { APPConstants, PlayingMusicData } from "datasource";
import { AppStorageV2 } from "@kit.ArkUI";
import { playerManager } from "utils";
import { HMRouterMgr } from "@hadss/hmrouter";

@ComponentV2
export struct PlayMusicComponent {
  @Local playingMusic: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!
  @Local imgStart: number = 0

  @Monitor('playingMusic.time')
  onTimeChange() {
    this.imgStart = this.calculateRotationAngle()
  }

  // 计算当前应该旋转的角度
  private calculateRotationAngle(): number {
    // 确保duration不为0，避免除零错误
    if (this.playingMusic.duration <= 0) {
      return 0;
    }

    // 根据播放进度计算角度 (time/duration) * 360°
    return (this.playingMusic.time / this.playingMusic.duration) * 360 * 3;
  }

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
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            angle: this.imgStart
          })
          // .onAppear(() => {
          //   setInterval(() => {
          //     this.imgStart += 1
          //     if (this.imgStart > 360) {
          //       this.imgStart = 0
          //     }
          //   }, 125)
          // })
          .transition(TransitionEffect.OPACITY.animation({ duration: 280, curve: Curve.Friction }))
          .animation({
            curve: Curve.Friction,
            duration: 280
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


      Image(this.playingMusic.isplay ? $r('app.media.playing_card_zanting') : $r('app.media.playing_component_play'))
        .width(35)
        .height(35)
        .padding(10)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .margin({ right: 20, top: 10 })
        .onClick(() => {
          this.playingMusic.isplay ? playerManager.paused() :
          playerManager.singPlay(this.playingMusic.playList[this.playingMusic.playIndex])
        })

    }
    .height(100)
    .width('100%')
    .backgroundColor('#80c2ce')
    .borderRadius({ topLeft: 35, topRight: 35 })
    .margin({ bottom: -25 })
    .padding({ left: '5%', right: '5%', top: 15 })
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      HMRouterMgr.push({
        pageUrl: 'PlayingPage',
        navigationId: 'mainNavigation',
        param: this.playingMusic.id
      })
    })
  }
}