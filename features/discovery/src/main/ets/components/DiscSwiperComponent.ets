import Constants from "../Contants/Constants"
import { CardInfo, CardsSource, CardStateType } from "../model/CardModel"

@ComponentV2
export struct DiscSwiperComponent {
  @Local cardList: CardInfo[] = []
  private data: CardsSource = new CardsSource([])
  @Local currentIndex: number = 0
  @Local offsetY: number = 0
  @Local cardStates: CardStateType[] = []
  private isDragging: boolean = false
  private startY: number = 0

  aboutToAppear(): void {
    Constants.CARD_LIST_INFO.forEach((item) => {
      this.cardList.push(item)
    });
    this.data = new CardsSource(this.cardList)
    this.updateCardStates() // 初始化卡片状态
  }

  // 更新所有卡片状态（适配循环逻辑）
  private updateCardStates(): void {
    this.cardStates = this.cardList.map((_, i) => {
      // 计算循环后的实际索引差（核心修改）
      const effectiveDiff = this.getEffectiveDiff(i)

      const angleFactor = effectiveDiff > 0 ? 1.2 : 1;
      // 使用循环后的索引差计算角度
      let angle = 180 - (effectiveDiff * Constants.CARD_ANGLE * angleFactor) - (this.offsetY * 0.3)

      // 确保角度在0-360度循环
      while (angle >= 360) {
        angle -= 360
      }
      while (angle < 0) {
        angle += 360
      }

      return {
        scale: this.getScale(angle),
        rotate: angle,
        zIndex: this.getZIndex(angle),
        opacity: this.getOpacity(angle),
        angle: angle
      } as CardStateType
    })
  }

  // 核心修改：计算循环后的有效索引差（解决循环逻辑）
  private getEffectiveDiff(targetIndex: number): number {
    const len = this.cardList.length
    if (len === 0) {
      return 0
    }

    // 将currentIndex映射到有效索引范围（0 ~ len-1）
    const normalizedCurrent = (this.currentIndex % len + len) % len
    // 计算目标索引与映射后当前索引的差
    let diff = targetIndex - normalizedCurrent

    // 处理循环场景：如果差的绝对值大于len/2，取更短路径（优化视觉连续性）
    if (diff > len / 2) {
      diff -= len
    } else if (diff < -len / 2) {
      diff += len
    }
    return diff
  }

  // 缩放逻辑保持不变（中间卡片最大）
  private getScale(angle: number): number {
    if (angle >= 90 && angle <= 270) { // 显示范围内的卡片
      const normalizedAngle = Math.abs(angle - 180) / 90
      return 1 - normalizedAngle * 0.3 // 越靠近中间越大
    }
    return 0.7 // 超出范围的卡片缩小
  }

  // 层级逻辑保持不变（中间卡片最上层）
  private getZIndex(angle: number): number {
    const normalizedAngle = Math.abs(angle - 180) / 90
    return 100 - normalizedAngle * 50 // 越靠近中间层级越高
  }

  // 透明度逻辑保持不变（中间卡片最清晰）
  private getOpacity(angle: number): number {
    if (angle >= 90 && angle <= 270) { // 显示范围内的卡片
      const normalizedAngle = Math.abs(angle - 180) / 90
      return 1 - normalizedAngle * 0.4 // 越靠近中间越清晰
    }
    return 0 // 超出范围的卡片隐藏
  }

  // 手势开始：记录初始位置
  private onGestureStart(event: GestureEvent): void {
    this.isDragging = true
    this.startY = event.offsetY
  }

  // 手势移动：实时更新偏移量和卡片状态
  private onGestureUpdate(event: GestureEvent): void {
    if (!this.isDragging) {
      return
    }
    const deltaY = event.offsetY - this.startY
    this.offsetY = deltaY
    this.updateCardStates() // 实时更新旋转和位置
  }

  // 手势结束：判断滑动方向并切换卡片
  private onGestureEnd(event: GestureEvent): void {
    this.isDragging = false
    const deltaY = event.offsetY - this.startY
    const threshold = 50

    if (Math.abs(deltaY) > threshold) {
      // 向下滑动（显示上一张）：currentIndex减1（允许为负）
      if (deltaY > 0) {
        this.currentIndex -= 1
      }
      // 向上滑动（显示下一张）：currentIndex加1（允许超过length-1）
      else if (deltaY < 0) {
        this.currentIndex += 1
      }
    }

    // 动画恢复初始位置
    animateTo({
      duration: 300,
      curve: Curve.Friction
    }, () => {
      this.offsetY = 0
      this.updateCardStates()
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 只显示当前卡片及前后各一张（共3张）
      LazyForEach(this.data, (card: CardInfo, index: number) => {

        if (this.cardList.length === 0) {

        } else {
          // 只显示当前卡片及前后各一张（循环逻辑下的3张卡片）
          if ((index - (this.currentIndex % this.cardList.length + this.cardList.length) % this.cardList.length +
          this.cardList.length) % this.cardList.length === 0 ||
            (index - (this.currentIndex % this.cardList.length + this.cardList.length) % this.cardList.length +
            this.cardList.length) % this.cardList.length === 1 ||
            (index - (this.currentIndex % this.cardList.length + this.cardList.length) % this.cardList.length +
            this.cardList.length) % this.cardList.length === this.cardList.length - 1) {
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

  @Builder
  private CardItem(card: CardInfo, index: number) {
    Column() {
      Row() {
        Image($r(card.img))
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
            .fontFamily('SoundHarborNormalFont')

          Text(card.introduce)
            .width('100%')
            .fontSize(20)
            .textAlign(TextAlign.Start)
            .margin({ top: 6 })
            .padding({ left: 5 })
            .opacity(0.7)
            .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
            .fontFamily('SoundHarborNormalFont')

          Text(card.singer)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontSize(18)
            .margin({ top: 6 })
            .padding({ left: 5 })
            .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
            .fontFamily('SoundHarborNormalFont')

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
          .fontFamily('SoundHarborNormalFont')
          .fontWeight(FontWeight.Medium)
          .height(80)
          .width(110)
          .letterSpacing(5)

        Text(card.price)
          .fontSize(25)
          .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
          .fontFamily('SoundHarborNormalFont')
          .backgroundColor(index % 2 === 0 ? $r('app.color.card_button_color_01') :
          $r('app.color.card_button_color_02'))
          .height(80)
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
        .letterSpacing(5)
        .textAlign(TextAlign.Center)
        .borderRadius(35)
        .fontColor(index % 2 === 0 ? $r('app.color.app_main_fontcolor') : $r('app.color.card_font_color_white'))
        .backgroundColor(index % 2 === 0 ? $r('app.color.card_button_color_01') :
        $r('app.color.card_button_color_02'))
        .fontFamily('SoundHarborNormalFont')

    }
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
    // 核心修改：旋转角度绑定到"水平方向与圆心的夹角"（state.angle）
    .rotate({
      z: this.cardStates[index].angle,
      angle: this.cardStates[index].angle + 180
    })
    .scale({ x: this.cardStates[index].scale, y: this.cardStates[index].scale })
    // 位置计算（基于圆形轨迹）
    .position({
      // 计算基础X、Y坐标（与原逻辑一致）
      x: Constants.CIRCLE_CENTER_X + Constants.CIRCLE_RADIUS * Math.cos(this.cardStates[index].angle * Math.PI / 180),
      y: this.cardStates[index].angle > 180 ? Constants.CIRCLE_CENTER_Y +
        Constants.CIRCLE_RADIUS * Math.sin(this.cardStates[index].angle * Math.PI / 180) :
        Constants.CIRCLE_CENTER_Y +
          Constants.CIRCLE_RADIUS * Math.sin(this.cardStates[index].angle * Math.PI / 180) * 1.3

    })
    .zIndex(this.cardStates[index].zIndex)
    .opacity(this.cardStates[index].opacity)
    .transition(TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Ease }))
  }
}