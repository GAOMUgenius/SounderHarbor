import { APPConstants } from "datasource"
import Constants from "../Contants/Constants"
import { CardInfo, CardsSource, CardStateType } from "../model/CardModel"

@ComponentV2
export struct DiscSwiperComponent {
  @Local cardList: CardInfo[] = []
  private data: CardsSource = new CardsSource([])
  @Local currentIndex: number = 0
  @Local offsetY: number = 0
  @Local cardStates: CardStateType[] = []
  @Local swipeDistance: number = 0
  // 原有滑动相关变量
  private isDragging: boolean = false
  private startY: number = 0

  aboutToAppear(): void {
    // 初始化卡片数据
    Constants.CARD_LIST_INFO.forEach((item) => {
      this.cardList.push(item)
    });
    this.data = new CardsSource(this.cardList)
    this.updateCardStates() // 初始化卡片状态
  }

  // 更新所有卡片状态
  private updateCardStates(): void {
    const displayIndex = this.currentIndex;
    this.cardStates = this.cardList.map((_, i) => {
      const effectiveDiff = this.getEffectiveDiff(i, displayIndex)
      const angleFactor = effectiveDiff > 0 ? 1.2 : 1;
      // 计算角度（
      let angle = 180 - (effectiveDiff * Constants.CARD_ANGLE * angleFactor) - (this.offsetY * 0.3)
      angle = (angle % 360 + 360) % 360
      return {
        angle: angle,
        scale: this.getScale(angle),
        rotate: angle,
        zIndex: this.getZIndex(angle),
        opacity: this.getOpacity(angle)
      } as CardStateType
    })
  }

  // 计算循环后的有效索引差
  private getEffectiveDiff(targetIndex: number, displayIndex: number): number {
    const len = this.cardList.length
    if (len === 0) {
      return 0
    }
    const normalizedCurrent = (displayIndex % len + len) % len
    let diff = targetIndex - normalizedCurrent
    // 处理循环场景
    if (diff > len / 2) {
      diff -= len
    } else if (diff < -len / 2) {
      diff += len
    }
    return diff
  }

  // 缩放逻辑
  private getScale(angle: number): number {
    if (angle >= 90 && angle <= 270) { // 显示范围内
      const normalizedAngle = Math.abs(angle - 180) / 90
      return 1 - normalizedAngle * 0.3
    }
    return 0.7
  }

  // 层级逻辑
  private getZIndex(angle: number): number {
    const normalizedAngle = Math.abs(angle - 180) / 90
    return 100 - normalizedAngle * 50
  }

  // 透明度逻辑
  private getOpacity(angle: number): number {
    if (angle >= 90 && angle <= 270) {
      const normalizedAngle = Math.abs(angle - 180) / 90
      return 1 - normalizedAngle * 0.4
    }
    return 0
  }

  // 线性插值工具
  private lerp(start: number, end: number, progress: number): number {
    return start + (end - start) * progress
  }

  // 手势开始（保留滑动逻辑）
  private onGestureStart(event: GestureEvent): void {
    this.isDragging = true
    this.startY = event.offsetY
    this.swipeDistance = 0
  }

  // 手势移动（保留滑动逻辑）
  private onGestureUpdate(event: GestureEvent): void {
    if (!this.isDragging) {
      return
    }
    const deltaY = event.offsetY - this.startY
    this.offsetY = deltaY
    this.swipeDistance = deltaY
    this.updateCardStates()
  }

  // 手势结束（保留滑动切换逻辑）
  private onGestureEnd(event: GestureEvent): void {
    this.isDragging = false
    const deltaY = event.offsetY - this.startY
    const threshold = 50

    if (Math.abs(deltaY) > threshold) {
      const step = Math.floor(Math.abs(deltaY) / 100) || 1
      this.currentIndex += deltaY > 0 ? -step : step
    }

    // 滑动结束后归位动画
    animateTo({
      duration: 300,
      curve: Curve.Friction
    }, () => {
      this.offsetY = 0
      this.updateCardStates()
    })
  }

  // 获取归一化的当前索引（保留）
  private getNormalizedCurrentIndex(): number {
    const len = this.cardList.length
    return len === 0 ? 0 : (this.currentIndex % len + len) % len
  }

  // 布局渲染（保留）
  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 只渲染当前卡片及前后各2张
      LazyForEach(this.data, (card: CardInfo, index: number) => {
        if (this.cardList.length !== 0) {
          if ((index - this.getNormalizedCurrentIndex() + this.cardList.length) % this.cardList.length <= 2 ||
            (index - this.getNormalizedCurrentIndex() + this.cardList.length) % this.cardList.length >=
              this.cardList.length - 2) {
            this.CardItem(card, index)
          }
        }
      }, (card: CardInfo) => card.id.toString())
    }
    .margin({ top: 65 })
    .height('100%')
    .width('100%')
    .gesture(
      PanGesture()
        .onActionStart(this.onGestureStart.bind(this))
        .onActionUpdate(this.onGestureUpdate.bind(this))
        .onActionEnd(this.onGestureEnd.bind(this))
    )
  }

  // 卡片布局（移除点击事件绑定）
  @Builder
  private CardItem(card: CardInfo, index: number) {
    Column() {
      // 卡片内容（保留原有布局）
      Row() {
        Image(card.img)
          .width(110)
          .height(110)
          .objectFit(ImageFit.Cover)
          .borderRadius(20)
        Column() {
          Text(card.title)
            .fontSize(24)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontWeight(500)
            .letterSpacing(3)
            .padding({ left: 5 })
            .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
            .fontFamily(APPConstants.APPFONTFAMILY)

          Text(card.introduce)
            .width('100%')
            .fontSize(20)
            .textAlign(TextAlign.Start)
            .margin({ top: 6 })
            .padding({ left: 5 })
            .opacity(0.7)
            .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
            .fontFamily(APPConstants.APPFONTFAMILY)

          Text(card.singer)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontSize(18)
            .margin({ top: 6 })
            .padding({ left: 5 })
            .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
            .fontFamily(APPConstants.APPFONTFAMILY)

          Rating({ rating: 2, indicator: true })
            .stars(5)
            .stepSize(0.1)
            .width(50)
            .margin({ top: 6, left: 5 })
            .starStyle({
              backgroundUri: '/../resources/base/media/discovery_card_star_off.svg',
              foregroundUri: '/../resources/base/media/discovery_card_star_on.svg'
            })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
        .width(145)
        .height(100)
      }
      .margin({ top: 20, left: 20 })
      .width(258)
      .justifyContent(FlexAlign.Start)

      Row() {
        Text(card.title)
          .fontSize(35)
          .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
          .fontFamily(APPConstants.APPFONTFAMILY)
          .fontWeight(FontWeight.Medium)
          .height(80)
          .width(150)
          .letterSpacing(5)

        Text(card.price)
          .fontSize(25)
          .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
          .fontFamily(APPConstants.APPFONTFAMILY)
          .backgroundColor(index % 2 === 0 ? $r('app.color.card_button_color_01') :
          $r('app.color.card_button_color_02'))
          .height(70)
          .margin({ right: 20 })
          .padding(5)
          .textAlign(TextAlign.Center)
          .borderRadius(15)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 20, left: 20 })
      .width(258)
      .justifyContent(FlexAlign.SpaceBetween)

      Text('购买')
        .margin({ top: 25, left: 20 })
        .width(230)
        .height(70)
        .fontSize(30)
        .letterSpacing(8)
        .textAlign(TextAlign.Center)
        .borderRadius(35)
        .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
        .backgroundColor(index % 2 === 0 ? $r('app.color.card_button_color_01') : $r('app.color.card_button_color_02'))
        .fontFamily(APPConstants.APPFONTFAMILY)
    }
    // 移除点击事件绑定（不再响应卡片点击）
    .height(370)
    .width(370)
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(index % 2 === 0 ? $r('app.color.card_background_color_01') :
    $r('app.color.card_background_color_02'))
    .borderRadius(50)
    .shadow({
      radius: 25,
      color: '#00000020',
      offsetX: 0,
      offsetY: 4
    })
    // 旋转角度（由卡片状态决定）
    .rotate({
      z: this.cardStates[index].angle,
      angle: this.cardStates[index].angle + 180
    })
    // 缩放（由卡片状态决定）
    .scale({ x: this.cardStates[index].scale, y: this.cardStates[index].scale })
    // 位置（基于角度计算）
    .position({
      x: Constants.CIRCLE_CENTER_X + Constants.CIRCLE_RADIUS * Math.cos(this.cardStates[index].angle * Math.PI / 180),
      y: this.cardStates[index].angle > 180
        ? Constants.CIRCLE_CENTER_Y + Constants.CIRCLE_RADIUS * Math.sin(this.cardStates[index].angle * Math.PI / 180)
        : Constants.CIRCLE_CENTER_Y +
          Constants.CIRCLE_RADIUS * Math.sin(this.cardStates[index].angle * Math.PI / 180) * 1.3
    })
    .zIndex(this.cardStates[index].zIndex)
    .opacity(this.cardStates[index].opacity)
    .transition(TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Ease }))
  }
}