import { CardSwiperComponent } from "../components/PlayListCardComponent"
import { PlayListTab } from "../components/PlayListTab"
import { TopicComponent } from "../components/TopicComponent"

@ComponentV2
export struct PlayPage {
  build() {
    Column() {
      TopicComponent()
      CardSwiperComponent()
      PlayListTab()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}