import { CardSwiperComponent } from "../components/PlayListCardComponent"
import { TopicComponent } from "../components/TopicComponent"

@ComponentV2
export struct PlayPage {
  build() {
    Column() {
      TopicComponent()
      CardSwiperComponent()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}