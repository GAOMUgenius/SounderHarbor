import { SwiperDataSource } from "../model/SwiperDataSource";
import { LengthMetrics } from "@kit.ArkUI";
import { Constants } from "../constants/Constants";
import { HostMusicData } from "../model/HostMusicModel";
import { APPConstants } from "datasource";


@ComponentV2
export struct RecommendComponent {
  //SwiperBanner区域变量
  @Local space: LengthMetrics = LengthMetrics.vp(0);
  @Local spacePool: LengthMetrics[] = [LengthMetrics.vp(0), LengthMetrics.px(3), LengthMetrics.vp(10)];
  @Local spaceIndex: number = 0;
  @Local ignoreSize: boolean = false;
  @Local ignoreSizePool: boolean[] = [false, true];
  @Local ignoreSizeIndex: number = 0;
  private swiperController1: SwiperController = new SwiperController();
  private swiperBannerData: SwiperDataSource = new SwiperDataSource([]);
  //热门推荐歌曲区域变量
  private hostMusicData: HostMusicData[] = []

  aboutToAppear(): void {
    //SwiperBanner初始化
    let list: string[] = Constants.RECOMMEND_SWIPERBANNER_SWIPERDATALISTINFO
    this.swiperBannerData = new SwiperDataSource(list);
    //热门推荐歌曲初始化
    this.hostMusicData = Constants.RECOMMEND_HOSTMUSIC_HOSTMUSICDATALISTINFO
  }

  build() {
    Scroll() {
      Column() {
        //SwiperBanner区域
        Column({ space: 20 }) {
          Swiper(this.swiperController1) {
            LazyForEach(this.swiperBannerData, (item: string) => {
              Column() {
                Image(item)
                  .width('100%')
                  .height(140)
                  .borderRadius(20)
                Column()
                  .height(30)
                  .width('100%')
              }
            }, (item: string) => item)
          }
          .autoPlay(true)
          .interval(6000)
          .indicator(new DotIndicator()
            .bottom(0)
            .itemWidth(8)
            .itemHeight(8)
            .selectedItemWidth(16)
            .selectedItemHeight(8)
            .color(Color.Gray)
            .selectedColor($r('app.color.home_recommend_swiper_indicator_color'))
            .maxDisplayCount(9))
        }
        .width('100%')
        .margin({ top: 20 })

        //热门推荐区域
        Column() {
          //热门标题区域
          Row() {
            Text('本周热门')
              .fontSize(22)
              .fontColor($r('app.color.app_main_fontcolor'))
              .fontFamily(APPConstants.APPFONTFAMILY)
              .letterSpacing(2)
            Image($r('app.media.home_recommend_right'))
              .width(25)
              .height(10)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

          //热门歌曲区域
          List() {
            ForEach(this.hostMusicData, (item: HostMusicData) => {
              ListItem() {
                this.HostMusicItem(item)
              }
            }, (item: HostMusicData) => item.id)
          }
          .scrollBar(BarState.Off)
          .margin({ top: 10 })
          .width('100%')
          .height(150)
          .listDirection(Axis.Horizontal)

        }

        //新专辑推荐区域
      }
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .height('auto')
  }

  @Builder
  HostMusicItem(hostMusic: HostMusicData) {
    Column() {
      Image(hostMusic.img)
        .width(100)
        .height(100)
        .borderRadius(15)
      Text(hostMusic.title)
        .fontSize(18)
        .fontColor($r('app.color.app_main_fontcolor'))
        .fontFamily(APPConstants.APPFONTFAMILY)
        .maxLines(1)
        .width(100)
        .margin({ top: 10 })
      Text(hostMusic.singer)
        .fontSize(14)
        .fontFamily(APPConstants.APPFONTFAMILY)
        .width(100)
    }
    .margin({ right: 5, left: 5 })
    .justifyContent(FlexAlign.Start)
  }
}