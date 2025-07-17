import Constants from "../constants/Contants"
import { CardInfo, CardsSource } from "../model/PlayListModel"
import { CommonUtil } from "utils"

@ComponentV2
export struct CardSwiperComponent {
  @Local cardList: CardInfo[] = []
  @Local cardListSource: CardsSource = new CardsSource([])
  @Local currentIndex: number = 1 // 当前居中卡片的索引

  aboutToAppear(): void {
    Constants.CARD_TEST_CASE.forEach((item) => {
      this.cardList.push((item))
    })
    this.cardListSource = new CardsSource(this.cardList)
  }

  build() {
    Swiper() {
      LazyForEach(this.cardListSource, (item: CardInfo, index: number) => {
        CardItem({
          card: item,
          index: index,
          currentIndex: this.currentIndex
        })
      })
    }
    .loop(false)
    .indicator(false)
    .displayCount(3) // 同时显示3张卡片
    .itemSpace(80) // 卡片之间的间距
    .onChange((index: number) => {
      this.currentIndex = (index + 1) % this.cardListSource.totalCount()
    })
    .margin({ top: 10 })
    .height(340) // 增加高度容纳缩放效果
    .width(700) // 确保宽度填满
  }
}

@ComponentV2
struct CardItem {
  @Param @Require card: CardInfo
  @Param @Require index: number // 当前卡片索引
  @Param @Require currentIndex: number // 居中卡片索引

  build() {
    Stack() {
      Image(this.card.src)
        .height(300)
        .width(240)
        .borderRadius(20)

      // 播放按钮（仅居中卡片显示）
      if (this.index === this.currentIndex) {
        Stack({ alignContent: Alignment.Center }) {
          Row()
            .size({ width: 50, height: 50 })
            .backgroundColor($r('app.color.play_button_background_color'))
            .borderRadius(15)

          Image($r('app.media.play_card_play'))
            .size({ width: 25, height: 25 })
        }
        .position({
          x: 150,
          y: 250
        })
      }
    }
    .scale({ x: this.index === this.currentIndex ? 1 : 0.85, y: this.index === this.currentIndex ? 1 : 0.85 }) // 应用缩放
    .zIndex(this.index === this.currentIndex ? 2 : 1) // 居中卡片在上层
    .animation({ duration: 300, curve: Curve.EaseInOut }) // 平滑动画
  }
}