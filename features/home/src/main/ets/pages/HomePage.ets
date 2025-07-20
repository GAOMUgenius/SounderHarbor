import { CategoryTab } from "../components/CategoryTab"
import { TopicComponent } from "../components/TopicComponent"

@ComponentV2
export struct HomePage {
  build() {
    Row() {
      Column() {
        TopicComponent()

        CategoryTab()


      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .padding({ left: "5%", right: "5%" })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}