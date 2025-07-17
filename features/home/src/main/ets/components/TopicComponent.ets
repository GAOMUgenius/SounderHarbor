import { APPConstants } from "datasource"

@Component
export struct TopicComponent {
  build() {
    Row() {
      Text('Home')
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontFamily(APPConstants.APPFONTFAMILY)
        .fontColor($r('app.color.app_main_fontcolor'))

      Image($r('app.media.home_user_img'))
        .size({
          width: 50,
          height: 50
        })
        .borderRadius(25)
    }
    .padding({ top: 15 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)

  }
}