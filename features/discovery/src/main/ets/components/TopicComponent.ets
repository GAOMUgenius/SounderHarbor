import { APPConstants } from "datasource"

@ComponentV2
export struct TopicComponent {
  build() {
    Row() {
      Text('Discovery')
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontFamily(APPConstants.APPFONTFAMILY)
        .fontColor($r('app.color.app_main_fontcolor'))

      Image($r('app.media.discovery_topic_serch'))
        .size({
          width: 35,
          height: 35
        })
        .onClick(() => {

        })
    }
    .padding({ top: 15 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)

  }
}