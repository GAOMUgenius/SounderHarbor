import { APPConstants } from "datasource";
import Constants from "../constants/Contants";
import { TabBarType, TabBarTypeData } from "../model/TabBarType";

@ComponentV2
export struct PlayListTab {
  @Local currentIndex: TabBarType = TabBarType.RENCENT
  private indicatorVisible: boolean = true

  build() {
    RelativeContainer() {
      Tabs({ index: this.currentIndex }) {
        TabContent() {
          // 第一个标签页内容
          Text('Recnt')
        }
        .tabBar('Recent')

        TabContent() {
          // 第二个标签页内容
          Text('like')
        }
        .tabBar('Like')
      }
      .scrollable(false) // 禁止滑动切换
      .barHeight(0)
      .vertical(true)
      .onChange((index: number) => {
        this.currentIndex = index;
        this.indicatorVisible = false;
        setTimeout(() => {
          this.indicatorVisible = true;
        }, 10);
      })

      // 自定义TabBar
      CustomPlayListTabBar({
        currentIndex: this.currentIndex,
        onTabChange: (index: TabBarType) => {
          this.currentIndex = index;
        }
      })
        .alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
        })
    }
    .layoutWeight(1)
  }
}

@ComponentV2
struct CustomPlayListTabBar {
  @Param currentIndex: TabBarType = TabBarType.RENCENT;
  @Param @Require onTabChange?: (index: TabBarType) => void;

  build() {
    Column() {
      // 指示器小圆点
      Circle()
        .width(6)
        .height(6)
        .fill($r('app.color.app_main_fontcolor'))
        .offset({ x: -15, y: this.currentIndex * 80 + 40 }) // 计算Y轴位置
        .opacity(1)
        .zIndex(1)
        .margin({ left: 5 })
        .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
        .animation({
          curve: Curve.Friction,
          duration: Constants.DURATION
        })

      // 标签项容器
      Column() {
        ForEach(Constants.TABBARTYPEDATA, (item: TabBarTypeData) => {
          TabItem({
            index: item.id,
            selectedIndex: this.currentIndex,
            onChange: (index: number) => {
              this.onTabChange?.(index);
            }
          })
        }, (item: TabBarTypeData) => item.id.toString())
      }
      .width(55)
      .height(200)
    }
    .width(55)
    .height(200)
  }
}

@ComponentV2
struct TabItem {
  @Param @Require index: number
  @Param @Require selectedIndex: number
  @Event onChange: (index: number) => void = () => {
  };

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 标签文本
      Text(Constants.TABBARTYPEDATA[this.index].title)
        .fontSize(this.index === this.selectedIndex ? 12 : 10)
        .fontWeight(this.index === this.selectedIndex ? FontWeight.Bold : FontWeight.Medium)
        .fontColor($r('app.color.app_main_fontcolor'))
        .fontFamily(APPConstants.APPFONTFAMILY)
        .textAlign(TextAlign.Center)
        .rotate({ angle: -90 })
        .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
        .animation({
          curve: Curve.Friction,
          duration: Constants.DURATION
        })
    }
    .width(55)
    .height(80)
    .onClick(() => {
      this.onChange(this.index);
    })
  }
}