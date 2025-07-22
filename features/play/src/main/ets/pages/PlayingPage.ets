import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { APPConstants, MusicData, PlayingMusicData } from "datasource";
import { numberToTime, playerManager } from "utils";
import { AudioBarProgress } from "../components/AudioBars";
import { AppStorageV2 } from "@kit.ArkUI";

@HMRouter({ pageUrl: "PlayingPage" })
@ComponentV2
export struct PlayingPage {
  @Local playingData: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!
  private swiperController1: SwiperController = new SwiperController();
  @Local audioBars: number[] = []
  @Local barCount: number = 30

  aboutToAppear(): void {
    let index = HMRouterMgr.getCurrentParam() as string;
    let newMusic: MusicData = {
      id: "",
      title: "",
      singer: "",
      img: "",
      url: ""
    }
    APPConstants.MUSICLISTINFO.forEach((item) => {
      if (item.id === index) {
        newMusic.id = index
        newMusic.title = item.title
        newMusic.singer = item.singer
        newMusic.img = item.img
        newMusic.url = item.url || undefined
      }
    })
    playerManager.singPlay(newMusic)
  }

  build() {
    Column() {
      //标题栏
      Row() {
        Image($r('app.media.playing_back_ic'))
          .width(40)
          .height(40)
          .padding(8)
          .backgroundColor('#fdf5eaee')
          .border({
            width: 2,
            color: $r('app.color.back_background_color')
          })
          .borderRadius(10)
          .onClick(() => {
            HMRouterMgr.pop({ navigationId: 'mainNavigation' })
          })

        Text('Now Playing')
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontColor($r('app.color.app_main_fontcolor'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Image($r('app.media.playing_share'))
          .width(30)
          .height(30)
      }
      .width('100%')

      .margin({ top: 10 })

      //歌曲信息栏
      Row() {
        Column() {
          Text(this.playingData.title)
          //TODO 跑马灯
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontFamily(APPConstants.APPFONTFAMILY)
            .fontColor($r('app.color.app_main_fontcolor'))
            .letterSpacing(3)
          Text(this.playingData.singer)
            .fontSize(24)
            .fontWeight(FontWeight.Medium)
            .fontFamily(APPConstants.APPFONTFAMILY)
            .fontColor($r('app.color.app_main_fontcolor'))
            .letterSpacing(1)
            .margin({ top: 15 })
        }
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.playing_like_ic_off'))
          .width(20)
          .height(20)
          .margin({ right: 10, top: 8 })
      }
      .padding({ left: 20, right: 20 })
      .height(100)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Top)
      .margin({ top: 20 })

      //歌曲封面与歌词
      RelativeContainer() {
        //背景框
        Row()
          .id('RowBorder')
          .width(295)
          .height(235)
          .border({
            width: 2,
            color: $r('app.color.back_background_color')
          })
          .borderRadius(20)
          .alignRules({
            'top': { 'anchor': 'Swpier', 'align': VerticalAlign.Top },
            'left': { 'anchor': 'Swpier', 'align': HorizontalAlign.Start }
          })
          .margin({ top: -7, left: -7 })

        Swiper(this.swiperController1) {
          //歌曲封面
          Column() {
            Image(this.playingData.img)
              .width(280)
              .height(220)
              .borderRadius(20)
            Column()
              .height(35)
              .width('100%')
          }

          //TODO 歌词部分
        }
        .id('Swpier')
        .loop(false)
        .indicator(new DotIndicator()
          .bottom(0)
          .itemWidth(8)
          .itemHeight(8)
          .selectedItemWidth(16)
          .selectedItemHeight(8)
          .color(Color.Gray)
          .selectedColor($r('app.color.playing_swiper_indicator_color'))
          .maxDisplayCount(9))
      }
      .height(265)
      .width(280)
      .margin({ top: 5 })

      //播放器
      RelativeContainer() {

        //背景板
        Stack() {
          Row()
            .border({
              width: 1,
              color: Color.Black
            })
            .width(315)
            .height(180)
            .borderRadius(50)
            .backgroundColor($r('app.color.play_button_background_color'))
        }
        .width(330)
        .height(200)
        .alignRules({
          'top': { 'anchor': 'playConatroll', 'align': VerticalAlign.Center },
          'left': { 'anchor': 'playConatroll', 'align': HorizontalAlign.Start }
        })
        .rotate({
          angle: 3
        })
        .borderRadius(50)
        .backgroundColor($r('app.color.play_controll_backcolor'))
        .margin({
          left: -15,
          top: 20
        })
        .border({
          width: 1,
          color: Color.Black
        })

        //播放器
        Column() {
          //
          Row() {
            Text(numberToTime(this.playingData.time))
              .fontSize(12)
              .width(60)
              .fontFamily(APPConstants.APPFONTFAMILY)
              .textAlign(TextAlign.Center)
              .fontColor($r('app.color.app_main_fontcolor'))
            AudioBarProgress({
              currentTime: this.playingData.time,
              totalDuration: this.playingData.duration
            })
            Text(numberToTime(this.playingData.duration))
              .fontSize(12)
              .width(60)
              .fontFamily(APPConstants.APPFONTFAMILY)
              .textAlign(TextAlign.Center)
              .fontColor($r('app.color.app_main_fontcolor'))
          }
          .width('100%')
          .height(100)

          //控制台
          Row() {
            //播放模式
            if (this.playingData.playMode === 'loop') {
              Image($r('app.media.playing_loop_list'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.playingData.playMode = 'radom'
                })
            } else if (this.playingData.playMode === 'radom') {
              Image($r('app.media.playing_radom_list'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.playingData.playMode = 'single'
                })
            } else if (this.playingData.playMode === 'single') {
              Image($r('app.media.playing_single_list'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.playingData.playMode = 'loop'
                })
            }
            Image($r('app.media.playing_pre_music'))
              .width(30)
              .height(30)
              .onClick(() => {
                playerManager.prevPlay()
              })
            Image(this.playingData.isplay ? $r('app.media.play_card_zanting') : $r('app.media.play_card_play'))
              .width(70)
              .height(70)
              .padding(18)
              .borderRadius(40)
              .backgroundColor($r('app.color.play_button_background_color'))
              .border({
                width: 2,
                color: $r('app.color.back_background_color')
              })
              .onClick(() => {
                this.playingData.isplay ? playerManager.paused() :
                playerManager.singPlay(this.playingData.playList[this.playingData.playIndex])
              })
            Image($r('app.media.playing_next_music'))
              .width(30)
              .height(30)
              .onClick(() => {
                playerManager.nextPlay()
              })
            Image($r('app.media.playing_play_list'))
              .width(30)
              .height(30)
              .onClick(() => {

              })


          }
          .justifyContent(FlexAlign.SpaceAround)
          .width("100%")
        }
        .id('playControll')
        .backgroundColor("#dcebf2")
        .height(250)
        .rotate({
          angle: 3
        })
        .border({
          width: 2,
          color: $r('app.color.back_background_color')
        })
        .borderRadius(30)
        .alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
        })

        //吊带
        Row()
          .width(10)
          .height(10)
          .borderRadius(5)
          .backgroundColor(Color.Black)
          .alignRules({
            'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
            'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
          })
          .margin({ top: -60, left: 30 })
          .border({
            width: 0.5,
            color: Color.White
          })
        Row()
          .width(10)
          .height(10)
          .borderRadius(5)
          .backgroundColor(Color.Black)
          .alignRules({
            'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
            'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
          })
          .margin({ top: 10, left: 30 })
        Row()
          .alignRules({
            'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
            'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
          })
          .width(3)
          .height(73)
          .backgroundColor("#ffe5e5e5")
          .border({
            width: 0.5,
            color: Color.Black
          })
          .margin({ top: -56, left: 34 })

      }.width(300)
      .height(300)

    }
    .width('100%')
    .height('100%')
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      repeating: false, // 渐变颜色是否重复
      colors: [[0xd4e9ee, 0.0], [0xf5eaee, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .justifyContent(FlexAlign.Start)
    .padding({ left: "5%", right: "5%" })

  }
}