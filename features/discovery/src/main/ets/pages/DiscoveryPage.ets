import { APPConstants } from "datasource";
import { DiscSwiperComponent } from "../components/DiscSwiperComponent";
import { TopicComponent } from "../components/TopicComponent";

@ComponentV2
export struct DiscoveryPage {
  build() {
    Column() {
      TopicComponent()
      Stack() {
        DiscSwiperComponent()
        Column() {
          Text('热门\n排行榜')
            .fontSize(40)
            .fontWeight(FontWeight.Bolder)
            .fontFamily(APPConstants.APPFONTFAMILY)
            .fontColor($r('app.color.app_main_fontcolor'))
            .letterSpacing(5)
            .fontWeight(FontWeight.Normal)
          Text('New Trending')
            .fontSize(20)
            .fontWeight(FontWeight.Bolder)
            .fontFamily(APPConstants.APPFONTFAMILY)
            .fontColor($r('app.color.discovery_trending_title_color'))
        }
        .alignItems(HorizontalAlign.Start)
        .position({
          x: 0,
          y: 20
        })

      }
    }
    .width('90%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}