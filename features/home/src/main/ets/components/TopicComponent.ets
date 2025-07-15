@Component
export struct TopicComponent {
  build() {
    Row() {
      Text('Home')
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontFamily('SoundHarborNormalFont')
        .fontColor($r('app.color.app_main_fontcolor'))

      Image($r('app.media.home_user_img'))
        .size({
          width: 60,
          height: 60
        })
        .borderRadius(30)
    }
    .padding({ top: 15 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)

  }
}