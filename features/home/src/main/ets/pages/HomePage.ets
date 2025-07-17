import { CategoryTab } from "../components/CategoryTab"
import { TopicComponent } from "../components/TopicComponent"

@ComponentV2
export struct HomePage {
  build() {
    Row() {
      Column() {
        TopicComponent()

        CategoryTab()
          .layoutWeight(1)


      }
      .alignItems(HorizontalAlign.Start)
      .width('90%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}