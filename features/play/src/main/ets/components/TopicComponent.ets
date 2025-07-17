import { APPConstants } from "datasource"

@ComponentV2
export struct TopicComponent {
  build() {
    Row() {
      Text('Home')
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontFamily(APPConstants.APPFONTFAMILY)
        .fontColor($r('app.color.app_main_fontcolor'))

      Image($r('app.media.play_topic_setting'))
        .size({
          width: 35,
          height: 35
        })
    }
    .padding({ top: 15, right: '5%', left: '5%' })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)

  }
}