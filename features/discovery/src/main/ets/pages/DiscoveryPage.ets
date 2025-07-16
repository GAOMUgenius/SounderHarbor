import { DiscSwiperComponent } from "../components/DiscSwiperComponent";
import { TopicComponent } from "../components/TopicComponent";

@ComponentV2
export struct DiscoveryPage {
  build() {
    Column() {
      TopicComponent()
      DiscSwiperComponent()
    }
    .width('90%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}