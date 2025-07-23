import { APPConstants, MusicListData } from "datasource";
import { CommonUtil } from "utils";
import { UserInfo } from "../model/UserModel";
import { LengthMetrics } from "@kit.ArkUI";

@ComponentV2
export struct MinePage {
  @Local currentYOffset: number = 0;
  private screenHeight?: number = AppStorage.get('screenHeight')
  private statusBarHeight?: number = AppStorage.get('statusHeight')
  private titleBarHeight: number = 80 + (this.statusBarHeight ? this.statusBarHeight : 0)
  @Local tabHeight: string =
    (this.screenHeight ? (this.screenHeight - this.titleBarHeight) / this.screenHeight : 1) * 100 + '%'
  private musicList: MusicListData[] = APPConstants.MINE_LIKE_MUSICLISTINFO
  private scrollerForScroll: Scroller = new Scroller();
  private scrollerForList: Scroller = new Scroller();
  @Local userInfo: UserInfo = new UserInfo()
  @Local indicatorLeftMargin: number = 0
  @Local indicatorWidth: number = 0
  @Local tabArray: [string, number][] =
    [['我的歌单', 0], ['收藏歌单', 1]]
  @Local currentIndex: number = 0
  @Local tabFontSizes: number[] = [22, 18]
  private textInfos: [number, number][] = []
  private isStartAnimateTo: boolean = false
  private tabsWidth: number = 0
  @Local animationDuration: number = 300

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontSize(this.tabFontSizes[index])
        .width(100)
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

  aboutToAppear(): void {
    for (let i = 0; i < this.tabArray.length; i++) {
      this.textInfos.push([0, 0]);
    }
    this.tabFontSizes[0] = 22
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Scroll(this.scrollerForScroll) {
        Column() {
          Row() {
            Image(this.userInfo.img)
              .width(120)
              .height(120)
              .margin({ left: 30 })
              .borderRadius(60)
            Column() {
              Text(this.userInfo.name)
                .fontColor($r('sys.color.white'))
                .fontFamily(APPConstants.APPFONTFAMILY)
                .fontSize(30)
                .width('100%')
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Bolder)
                .letterSpacing(3)
              Text(this.userInfo.account)
                .fontColor($r('sys.color.white'))
                .fontFamily(APPConstants.APPFONTFAMILY)
                .fontSize(25)
                .width('100%')
                .textAlign(TextAlign.Start)
                .letterSpacing(1)
              Button('编辑资料')
                .backgroundColor($r('sys.color.white'))
                .fontColor($r('app.color.app_main_fontcolor'))
                .fontFamily(APPConstants.APPFONTFAMILY)
                .fontSize(18)
                .width(120)
                .height(40)
                .margin({ top: 10 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 15 })
            .layoutWeight(1)
          }
          .width("100%")
          .height(220)
          .linearGradient({
            direction: GradientDirection.Bottom, // 渐变方向
            repeating: false, // 渐变颜色是否重复
            colors: [[0x88c6ce, 0.0], [0xc2c5d3, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
          })

          Stack({ alignContent: Alignment.TopStart }) {
            Column()
              .height(30)
              .borderRadius(15)
              .width(this.indicatorWidth)
              .margin({ start: LengthMetrics.vp(this.indicatorLeftMargin), top: LengthMetrics.vp(15) })
              .backgroundColor($r('app.color.tab_sellcted_color'))


            Tabs({ barPosition: BarPosition.Start }) {
              TabContent() {
                List({ space: 20, scroller: this.scrollerForList }) {
                  ForEach(this.musicList, (item: MusicListData) => {
                    ListItem() {
                      Row() {
                        Image(item.list_img)
                          .width(60)
                          .height(60)
                          .borderRadius(15)
                          .margin({ left: 20 })
                        Column() {
                          Text(item.list_title)
                            .fontFamily(APPConstants.APPFONTFAMILY)
                            .fontColor($r('app.color.app_main_fontcolor'))
                            .width(180)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                            .textAlign(TextAlign.Start)
                            .fontSize(20)
                          Text(item.list_user_name)
                            .fontFamily(APPConstants.APPFONTFAMILY)
                            .fontColor($r('app.color.app_main_fontcolor'))
                            .width(180)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                            .textAlign(TextAlign.Start)
                            .margin({ top: 10 })
                        }
                        .alignItems(HorizontalAlign.Start)
                        .margin({ left: 10 })
                      }
                      .width("90%")
                      .height(90)
                      .borderRadius(30)
                      .backgroundColor('#f7d6df')
                    }
                  }, (item: MusicListData) => item.list_id)
                }
                .nestedScroll({
                  scrollForward: NestedScrollMode.PARENT_FIRST,
                  scrollBackward: NestedScrollMode.SELF_FIRST
                })
                .padding({ left: 10, right: 10 })
                .width("100%")
                .edgeEffect(EdgeEffect.None)
                .scrollBar(BarState.Off)
                .alignListItem(ListItemAlign.Center)
              }.tabBar(this.tabBuilder(0, this.tabArray[0][0]))

              TabContent() {
                List({ space: 20, scroller: this.scrollerForList }) {
                  ForEach(this.musicList, (item: MusicListData) => {
                    ListItem() {
                      Row() {
                        Image(item.list_img)
                          .width(60)
                          .height(60)
                          .borderRadius(15)
                          .margin({ left: 20 })
                        Column() {
                          Text(item.list_title)
                            .fontFamily(APPConstants.APPFONTFAMILY)
                            .fontColor($r('app.color.app_main_fontcolor'))
                            .width(180)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                            .textAlign(TextAlign.Start)
                            .fontSize(20)
                          Text(item.list_user_name)
                            .fontFamily(APPConstants.APPFONTFAMILY)
                            .fontColor($r('app.color.app_main_fontcolor'))
                            .width(180)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                            .textAlign(TextAlign.Start)
                            .margin({ top: 10 })
                        }
                        .margin({ left: 10 })
                      }
                      .width("90%")
                      .height(90)
                      .borderRadius(30)
                      .backgroundColor('#f7d6df')
                    }
                  }, (item: MusicListData) => item.list_id.toString())
                }
                .nestedScroll({
                  scrollForward: NestedScrollMode.PARENT_FIRST,
                  scrollBackward: NestedScrollMode.SELF_FIRST
                })
                .padding({ left: 10, right: 10 })
                .width("100%")
                .edgeEffect(EdgeEffect.None)
                .scrollBar(BarState.Off)
                .alignListItem(ListItemAlign.Center)
              }.tabBar(this.tabBuilder(1, this.tabArray[1][0]))
            }
            .vertical(false)
            .barMode(BarMode.Fixed)
            .barHeight(56)
            .width("100%")
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
              this.startAnimateTo(this.animationDuration, this.textInfos[targetIndex][0],
                this.textInfos[targetIndex][1])
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
          .backgroundColor('#F1F3F5')
          .margin({ top: this.currentYOffset > 140 ? ((this.currentYOffset - 140) / 40) * 40 : 0 })
          .borderRadius({ topLeft: 20, topRight: 20 })
        }
      }
      .scrollBar(BarState.Off)
      .width("100%")
      .onWillScroll((xOffset: number, yOffset: number) => {
        this.currentYOffset = this.scrollerForScroll.currentOffset().yOffset;
      })

      Row() {
        Image(this.userInfo.img)
          .size({
            width: 50,
            height: 50
          })
          .borderRadius(25)

        Text(this.userInfo.name)
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontColor($r('app.color.app_main_fontcolor'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .letterSpacing(1)
          .margin({ left: 20 })

      }
      .alignItems(VerticalAlign.Center)
      // .backgroundColor("#d6e8f0")
      .width('100%')
      .height(this.titleBarHeight)
      //渐变色范围150， 需要更改为（粉色图片高度 - titleBar高度 - 状态栏高度）
      .opacity(this.currentYOffset > 150 ? (this.currentYOffset - 150) / 100 : 0)
      .padding({ top: this.statusBarHeight, left: '5%', right: '5%' })
      .linearGradient({
        direction: GradientDirection.Bottom, // 渐变方向
        repeating: false, // 渐变颜色是否重复
        colors: [[0x88c6ce, 0.0], [0xc2c5d3, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
      })
    }
    .width('100%')
    .backgroundColor('#c2c5d3')
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
      this.indicatorLeftMargin = leftMargin
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