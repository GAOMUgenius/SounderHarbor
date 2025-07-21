import Constants from "../constants/Contants"
import { AppStorageV2, display } from "@kit.ArkUI"
import { HMRouterMgr } from "@hadss/hmrouter";
import { APPConstants, MusicData, PlayingMusicData, PlayListSource } from "datasource";

@ComponentV2
export struct CardSwiperComponent {
  @Local cardsList: MusicData[] = []
  @Local cardsOffset: number[] = [];
  @Local currentSwiperIndex: number = 0
  @Local cardsScale: number[] = [];
  @Local data: PlayListSource = new PlayListSource([]);
  private displayWidth: number = 0;
  private swiperMargin: number = Constants.SWIPER_MARGIN;
  @Local playingMusicList: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!

  @Monitor('playingMusicList')
  onListChange() {
    console.log('播放列表发生变化了')
  }

  aboutToAppear(): void {
    const displayData: display.Display = display.getDefaultDisplaySync();
    this.displayWidth = this.getUIContext().px2vp(displayData.width);
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if ((display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) ||
        this.displayWidth >= Constants.DEVICE_SIZE) {
        this.displayWidth = this.getUIContext().px2vp(displayData.width) / 2;
      }
    }

    this.playingMusicList.playList.forEach((item) => {
      this.cardsList.push(item);
      this.cardsOffset.push(0);
      this.cardsScale.push(1.0);
    })
    this.data = new PlayListSource(this.cardsList);
    this.calculateOffset(0);
  }

  build() {
    Column() {
      Swiper() {
        LazyForEach(this.data, (item: MusicData, index: number) => {
          CardComponent({
            cardInfo: item,
            cardOffset: this.cardsOffset[index],
            cardScale: this.cardsScale[index],
            cardIndex: index,
            showingCard: this.currentSwiperIndex
          })
        }, (item: MusicData) => item.id.toString())
      }
      .indicator(false)
      .index(this.currentSwiperIndex)
      .loop(false)
      .prevMargin(this.swiperMargin)
      .nextMargin(this.swiperMargin)
      .duration(Constants.DURATION)
      .curve(Curve.Friction)
      .onChange((index: number) => {
        this.calculateOffset(index);
        this.currentSwiperIndex = index;
      })
      .onGestureSwipe((index, event) => {
        const currentOffset = event.currentOffset;
        const maxOffset = this.getMaxOffset(index) / 2;
        const progress = Math.min(1, Math.abs(currentOffset) / this.displayWidth);

        // 当前卡片缩放：1.0 → 0.95
        this.cardsScale[index] = 1.0 - progress * 0.05;

        // 左侧卡片缩放：0.85 → 0.95
        if (currentOffset < 0 && this.isIndexValid(index + 1)) {
          this.cardsScale[index + 1] = 0.85 + progress * 0.1;
        }

        // 右侧卡片缩放：0.85 → 0.95
        if (currentOffset > 0 && this.isIndexValid(index - 1)) {
          this.cardsScale[index - 1] = 0.85 + progress * 0.1;
        }

        if (currentOffset < 0) {
          this.cardsOffset[index] = (-currentOffset / this.displayWidth) * maxOffset + maxOffset;
          if (this.isIndexValid(index + 1)) {
            const maxOffset = this.getMaxOffset(index + 1) / 2;
            this.cardsOffset[index + 1] = (-currentOffset / this.displayWidth) * maxOffset;
          }
          if (this.isIndexValid(index - 1)) {
            const maxOffset = this.getMaxOffset(index - 1) / 2;
            this.cardsOffset[index - 1] = (currentOffset / this.displayWidth) * maxOffset + 2 * maxOffset;
          }
        } else if (currentOffset > 0) {
          this.cardsOffset[index] = maxOffset - (currentOffset / this.displayWidth) * maxOffset;
          if (this.isIndexValid(index + 1)) {
            const maxOffset = this.getMaxOffset(index + 1) / 2;
            this.cardsOffset[index + 1] = (currentOffset / this.displayWidth) * maxOffset;
          }
          if (this.isIndexValid(index - 1)) {
            const maxOffset = this.getMaxOffset(index - 1) / 2;
            this.cardsOffset[index - 1] = 2 * maxOffset - (currentOffset / this.displayWidth) * maxOffset;
          }
        }
      })
      .onAnimationStart((_index, targetIndex) => {
        // 只重置非相邻卡片的缩放
        this.cardsList.forEach((_, i) => {
          if (Math.abs(i - targetIndex) > 1) {
            this.cardsScale[i] = 0.85;
          }
        });
        // 确保相邻卡片保持正确缩放
        this.calculateOffset(targetIndex); // 内部已设置左右卡片为0.85
      })
      .onAnimationEnd(() => {

      })
      .height(300)
    }
    .width('100%')
    .height(300)
    .margin({ top: 20 })
    .justifyContent(FlexAlign.Center)
  }

  calculateOffset(target: number) {
    let left = target - 1;
    let right = target + 1;

    if (this.isIndexValid(left)) {
      this.cardsOffset[left] = this.getMaxOffset(left);
    }
    if (this.isIndexValid(target)) {
      this.cardsOffset[target] = this.getMaxOffset(target) / 2;
    }
    if (this.isIndexValid(right)) {
      this.cardsOffset[right] = 0;
    }
    if (this.isIndexValid(left)) {
      this.cardsScale[left] = 0.85; // 左侧卡片缩小
    }
    if (this.isIndexValid(target)) {
      this.cardsScale[target] = 1.0; // 中间卡片正常大小
    }
    if (this.isIndexValid(right)) {
      this.cardsScale[right] = 0.85; // 右侧卡片缩小
    }
  }

  isIndexValid(index: number): boolean {
    return index >= 0 && index < this.cardsList.length;
  }

  getMaxOffset(index: number): number {
    return this.displayWidth - Constants.CARD_WIDTH - 2 * this.swiperMargin;
  }
}


@ComponentV2
struct CardComponent {
  @Param @Require cardInfo: MusicData
  @Local cardWith: number = Constants.CARD_WIDTH;
  @Local cardHeight: number = Constants.CARD_HEIGHT;
  @Local buttonSize: number = 50
  @Local iconSize: number = 25
  @Local isTablet: boolean = false;
  @Local screenW: number = this.getUIContext().px2vp(display.getDefaultDisplaySync().width);
  @Local isPhotoShow: boolean = false;
  @Param cardOffset: number = 0;
  @Param showingCard: number = 0;
  @Param cardIndex: number = 0;
  @Local buttonMargin: number = 20; // 添加按钮边距变量
  @Param cardScale: number = 1.0;

  @Monitor('cardScale')
  oncardSaleChange() {
    this.cardWith = Constants.CARD_WIDTH * this.cardScale;
    this.cardHeight = Constants.CARD_HEIGHT * this.cardScale;
    this.buttonMargin = Constants.CARD_WIDTH * 0.05 * this.cardScale;
    this.buttonSize = 50 * this.cardScale
    this.iconSize = 25 * this.cardScale
  }

  aboutToAppear(): void {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if ((display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) ||
        this.screenW >= Constants.DEVICE_SIZE) {
        this.isTablet = true;
      } else {
        this.isTablet = false;
      }
    }
    this.cardWith = Constants.CARD_WIDTH * this.cardScale;
    this.cardHeight = Constants.CARD_HEIGHT * this.cardScale;
    this.buttonMargin = Constants.CARD_WIDTH * 0.05 * this.cardScale;
  }

  build() {
    Row() {
      RelativeContainer() {
        Image(this.cardInfo.img)
          .id("cardImage")
          .width(this.cardWith)
          .height(this.cardHeight)
          .objectFit(ImageFit.Cover)
          .borderRadius(30)
          .shadow({
            radius: 20,
            type: ShadowType.COLOR,
            color: '#1800001e'
          })
          .onTouch((event) => {
            if (event) {
              if (event.type === TouchType.Down) {
                this.cardWith = Constants.CARD_WIDTH * 0.9 * this.cardScale;
                this.cardHeight = Constants.CARD_HEIGHT * 0.9 * this.cardScale;
                this.buttonSize = 50 * 0.9 * this.cardScale
                this.iconSize = 25 * 0.9 * this.cardScale
                this.buttonMargin = this.cardWith * 0.05 * this.cardScale;
              }
              if (event.type === TouchType.Up) {
                this.cardWith = Constants.CARD_WIDTH * this.cardScale;
                this.cardHeight = Constants.CARD_HEIGHT * this.cardScale;
                this.buttonSize = 50 * this.cardScale
                this.iconSize = 25 * this.cardScale
                this.buttonMargin = Constants.CARD_WIDTH * 0.05 * this.cardScale;
              }
            }
          })
          .geometryTransition(this.cardIndex.toString(), { follow: true })
          .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
          .animation({
            curve: Curve.Friction,
            duration: Constants.DURATION
          })

        Stack({ alignContent: Alignment.Center }) {
          Row()
            .width(this.buttonSize)
            .height(this.buttonSize)
            .backgroundColor($r('app.color.play_button_background_color'))
            .borderRadius(15)
            .shadow({
              radius: 20,
              type: ShadowType.COLOR,
              color: '#1800001e'
            })
            .geometryTransition(this.cardIndex.toString(), { follow: true })
            .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
            .animation({
              curve: Curve.Friction,
              duration: Constants.DURATION
            })

          Image($r('app.media.play_card_play'))
            .width(this.iconSize)
            .height(this.iconSize)
            .geometryTransition(this.cardIndex.toString(), { follow: true })
            .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
            .animation({
              curve: Curve.Friction,
              duration: Constants.DURATION
            })
        }
        .id("playButton") // 设置ID用于相对定位
        .size({ width: this.buttonSize, height: this.buttonSize })
        .margin({ right: this.buttonMargin, bottom: this.buttonMargin }) // 使用动态边距
        .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
        .animation({
          curve: Curve.Friction,
          duration: Constants.DURATION
        })
        // 设置按钮在图片右下角的相对位置
        .alignRules({
          right: { anchor: "cardImage", align: HorizontalAlign.End },
          bottom: { anchor: "cardImage", align: VerticalAlign.Bottom }
        })
      }
      .width(this.cardWith) // 设置容器宽度与图片一致
      .height(this.cardHeight)
      .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
      .animation({
        curve: Curve.Friction,
        duration: Constants.DURATION
      })
      .alignRules({
        top: { anchor: "__container__", align: VerticalAlign.Center },
        left: { anchor: "__container__", align: HorizontalAlign.Center },
        right: { anchor: "__container__", align: HorizontalAlign.Center }
      })
    }
    .width(this.cardWith)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      HMRouterMgr.push({
        pageUrl: 'PlayingPage',
        navigationId: 'mainNavigation',
        param: this.cardInfo.id
      })
    })
  }
}