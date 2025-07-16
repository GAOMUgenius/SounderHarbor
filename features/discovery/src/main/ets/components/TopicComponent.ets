@ComponentV2
export struct TopicComponent {
  build() {
    Row() {
      Text('Discovery')
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .fontFamily('SoundHarborNormalFont')
        .fontColor($r('app.color.app_main_fontcolor'))

      Image($r('app.media.discovery_topic_serch'))
        .size({
          width: 50,
          height: 50
        })
    }
    .padding({ top: 15 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)

  }
}