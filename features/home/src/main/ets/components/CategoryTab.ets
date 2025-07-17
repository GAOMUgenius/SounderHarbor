import { CommonUtil } from "utils"
import { CategoryType } from "../model/CategoriesModel"
import { LengthMetrics } from "@kit.ArkUI"
import { RecommendComponent } from "./RecommendComponent"
import { APPConstants } from "datasource"

@ComponentV2
export struct CategoryTab {
  @Local tabArray: [string, CategoryType][] =
    [['推荐', CategoryType.RECOMMEND], ['排行', CategoryType.RANKING], ['专辑', CategoryType.ALBUM],
      ['关注', CategoryType.CONCERN]]
  @Local currentIndex: CategoryType = CategoryType.RECOMMEND
  @Local animationDuration: number = 300
  @Local indicatorLeftMargin: number = 0
  @Local indicatorWidth: number = 0
  @Local tabFontSizes: number[] = [22, 18, 18, 18]
  private tabsWidth: number = 0
  private textInfos: [number, number][] = []
  private isStartAnimateTo: boolean = false

  aboutToAppear(): void {
    for (let i = 0; i < this.tabArray.length; i++) {
      this.textInfos.push([0, 0]);
    }
    this.tabFontSizes[0] = 22
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)// .fontSize(this.currentIndex === index ? 22 : 18)
        .fontSize(this.tabFontSizes[index])
        .width(80)
        .textAlign(TextAlign.Center)
        .fontFamily(APPConstants.APPFONTFAMILY)
        .fontColor(this.currentIndex === index ? $r('app.color.tab_background_color') : $r('app.color.tab_title_color'))
        .fontWeight(this.currentIndex === index ? 700 : 500)
        .id(index.toString())
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.textInfos[index] = [newValue.globalPosition.x as number, newValue.width as number]
          if (!this.isStartAnimateTo && this.currentIndex === index && this.tabsWidth > 0) {
            this.setIndicatorAttr(this.textInfos[this.currentIndex][0], this.textInfos[this.currentIndex][1])
          }
        })
    }.width('100%')
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column()
        .height(30)
        .borderRadius(15)
        .width(this.indicatorWidth)
        .margin({ start: LengthMetrics.vp(this.indicatorLeftMargin), top: LengthMetrics.vp(10.07) })
        .backgroundColor($r('app.color.tab_sellcted_color'))

      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          RecommendComponent()
            .layoutWeight(1)
        }
        .tabBar(this.tabBuilder(CategoryType.RECOMMEND, this.tabArray[0][0]))

        TabContent() {
          Text(this.tabArray[1][0])
            .layoutWeight(1)
        }
        .tabBar(this.tabBuilder(CategoryType.RANKING, this.tabArray[1][0]))

        TabContent() {
          Text(this.tabArray[2][0])
            .layoutWeight(1)
        }
        .tabBar(this.tabBuilder(CategoryType.ALBUM, this.tabArray[2][0]))

        TabContent() {
          Text(this.tabArray[3][0])
            .layoutWeight(1)
        }
        .tabBar(this.tabBuilder(CategoryType.CONCERN, this.tabArray[3][0]))
      }
      .barHeight(50)
      .width('100%')
      // .height('auto') //设置高度为自定义，避免高度计算错误
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.None)
      .animationDuration(this.animationDuration)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.tabsWidth = newValue.width as number
        if (!this.isStartAnimateTo) {
          this.setIndicatorAttr(this.textInfos[this.currentIndex][0], this.textInfos[this.currentIndex][1])
        }
      })
      .onChange((index: number) => {
        this.currentIndex = index // 监听索引index的变化，实现页签内容的切换。
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        // 切换动画开始时触发该回调。下划线跟着页面一起滑动，同时宽度渐变。
        this.startAnimateTo(this.animationDuration, this.textInfos[targetIndex][0], this.textInfos[targetIndex][1])
        this.animateFontSize(targetIndex, index) // 新增：开始字体大小动画
        this.currentIndex = targetIndex
      })
      .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
        // 切换动画结束时触发该回调。下划线动画停止。
        let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event)
        this.startAnimateTo(0, currentIndicatorInfo.left, currentIndicatorInfo.width)
        this.updateFontSize(currentIndicatorInfo.index) // 新增：更新字体大小
      })

      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        // 在页面跟手滑动过程中，逐帧触发该回调。
        let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event)
        this.currentIndex = currentIndicatorInfo.index
        this.setIndicatorAttr(currentIndicatorInfo.left, currentIndicatorInfo.width)
        this.updateFontSizeOnSwipe(index, currentIndicatorInfo.index, event.currentOffset) // 新增：滑动时更新字体大小
      })

    }
    .width('100%')
  }

  private getCurrentIndicatorInfo(index: number, event: TabsAnimationEvent): Record<string, number> {
    let nextIndex = index
    if (index > 0 && (CommonUtil.getIsRTL() ? event.currentOffset < 0 : event.currentOffset > 0)) {
      nextIndex--
    } else if (index < this.textInfos.length - 1 &&
      (CommonUtil.getIsRTL() ? event.currentOffset > 0 : event.currentOffset < 0)) {
      nextIndex++
    }
    let indexInfo = this.textInfos[index]
    let nextIndexInfo = this.textInfos[nextIndex]
    let swipeRatio = Math.abs(event.currentOffset / this.tabsWidth)
    let currentIndex = swipeRatio > 0.5 ? nextIndex : index // 页面滑动超过一半，tabBar切换到下一页。
    let currentLeft = indexInfo[0] + (nextIndexInfo[0] - indexInfo[0]) * swipeRatio
    let currentWidth = indexInfo[1] + (nextIndexInfo[1] - indexInfo[1]) * swipeRatio
    return { 'index': currentIndex, 'left': currentLeft, 'width': currentWidth }
  }

  private startAnimateTo(duration: number, leftMargin: number, width: number) {
    this.isStartAnimateTo = true
    animateTo({
      duration: duration, // 动画时长
      curve: Curve.Linear, // 动画曲线
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        this.isStartAnimateTo = false
        console.info('play end')
      }
    }, () => {
      this.setIndicatorAttr(leftMargin, width)
    })
  }

  private setIndicatorAttr(leftMargin: number, width: number) {
    this.indicatorWidth = width
    if (CommonUtil.getIsRTL()) {
      this.indicatorLeftMargin = this.tabsWidth - leftMargin - width
    } else {
      this.indicatorLeftMargin = leftMargin - 19
    }
  }

  // 新增：字体大小动画函数
  private animateFontSize(targetIndex: number, currentIndex: number) {
    animateTo({
      duration: this.animationDuration,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal
    }, () => {
      // 重置所有字体大小
      for (let i = 0; i < this.tabFontSizes.length; i++) {
        this.tabFontSizes[i] = 18
      }
      // 设置目标标签的字体大小
      this.tabFontSizes[targetIndex] = 22
    })
  }

  // 新增：滑动时更新字体大小
  private updateFontSizeOnSwipe(currentIndex: number, targetIndex: number, offset: number) {
    const swipeRatio = Math.abs(offset / this.tabsWidth)

    // 重置所有字体大小
    for (let i = 0; i < this.tabFontSizes.length; i++) {
      this.tabFontSizes[i] = 18
    }
    if (this.currentIndex === currentIndex) {
      this.tabFontSizes[currentIndex] = 22 - (4 * swipeRatio)
      for (let i = 0; i < this.tabFontSizes.length; i++) {
        if (i !== currentIndex) {
          this.tabFontSizes[i] = 18
        }
      }
    } else {
      // 如果当前页已经切换，那么按照动画进度调整
      this.tabFontSizes[currentIndex] = 18 + (4 * swipeRatio) // 从18px增大到22px
      this.tabFontSizes[targetIndex] = 22 - (4 * swipeRatio) // 从22px减小到18px
    }
  }

  // 新增：更新字体大小
  private updateFontSize(index: number) {
    // 重置所有字体大小
    for (let i = 0; i < this.tabFontSizes.length; i++) {
      this.tabFontSizes[i] = 18
    }
    // 设置当前标签的字体大小
    this.tabFontSizes[index] = 22
  }
}