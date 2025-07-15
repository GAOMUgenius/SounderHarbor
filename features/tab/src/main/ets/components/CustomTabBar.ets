import { TabBarType, tabBarTypeData, TabBarTypeData } from "../model/TabBarType";

@ComponentV2
export struct CustomTabBar {
  @Consumer('currentIndex') currentIndex: TabBarType = TabBarType.HOME;

  onChange(index: TabBarType): void {
    this.currentIndex = index;
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceAround
    }) {
      ForEach(tabBarTypeData, (item: TabBarTypeData) => {
        TabItem({
          index: item.id,
          selectedIndex: this.currentIndex,
          onChange: (index: number) => this.onChange(index)
        })
      }, (item: TabBarTypeData) => item.id.toString())
    }
    .backgroundBlurStyle(BlurStyle.NONE)
    .backgroundColor($r('app.color.tab_background_color'))
    .borderRadius({ topLeft: 25, topRight: 25 })
    .padding({ bottom: 0 })
    .clip(false)
    .height(70)
    .width('100%')
  }
}

@ComponentV2
struct TabItem {
  @Param @Require index: number
  @Param @Require selectedIndex: number
  @Local showAnimation: boolean = false;
  @Local backgroundWidth: number = 0
  @Local backgroundHeight: number = 40
  @Local iconX: number = 30
  @Local titleX: number = 40
  @Event onChange: (index: number) => void = () => {
  };

  @Monitor('selectedIndex')
  watchSelectedIndexChange(monitor: IMonitor) {
    if (this.selectedIndex === this.index) {
      // 被选中时放大背景
      this.backgroundWidth = 90
      this.iconX = 10
      this.titleX = 40
    } else {
      // 取消选中时重置背景
      this.backgroundWidth = 0
      this.iconX = 30
    }
  }

  aboutToAppear() {
    // 初始化时设置正确的大小
    if (this.selectedIndex === this.index) {
      this.backgroundWidth = 90
      this.iconX = 10
    }
  }

  build() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Row()
          .width(this.backgroundWidth)
          .height(this.backgroundHeight)
          .backgroundColor($r('app.color.tab_sellcted_color'))
          .borderRadius(20)
          .animation({
            duration: 300, // 缩短动画时间
            curve: Curve.EaseOut,
            iterations: 1, // 只播放一次
            playMode: PlayMode.Normal
          })
        Row() {
          Image(tabBarTypeData[this.index].icon)
            .size({
              width: 30,
              height: 30
            })
            .position({
              x: this.iconX,
              y: 19
            })
            .animation({
              duration: 300,
              curve: Curve.EaseOut,
              iterations: 1,
              playMode: PlayMode.Normal
            })
          if (this.selectedIndex === this.index) {
            Text(tabBarTypeData[this.index].title)
              .width(40)
              .height(30)
              .fontSize(14)
              .fontWeight(FontWeight.Bolder)
              .textAlign(TextAlign.Center)
              .fontWeight(600)
              .fontFamily('SoundHarborNormalFont')
              .fontColor($r('app.color.tab_title_color'))// .padding({ top: 5 })
              .position({
                x: this.titleX,
                y: 19
              })
              .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
          }
        }
        .width('100%')
        .height('100%')

      }
      .width('100%')
      .height('100%')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .clip(false)
    .padding({ left: 4, right: 4, top: 5 })
    .layoutWeight(1)
    .size({ width: '80%', height: '100%' })
    .onClick(() => {
      if (this.selectedIndex !== this.index) {
        this.showAnimation = true;
        this.onChange(this.index);
        setTimeout(() => {
          this.showAnimation = false;
        }, 300)
      }
    })
  }
}