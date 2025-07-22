import Constants from "../constants/Contants"
import { AppStorageV2, display } from "@kit.ArkUI"
import { HMRouterMgr } from "@hadss/hmrouter";
import { APPConstants, MusicData, PlayingMusicData, PlaylistChangeEventData, PlayListSource } from "datasource";
import { emitter } from "@kit.BasicServicesKit";
import { playerManager } from 'utils'

@ComponentV2
export struct CardSwiperComponent {
  @Local cardsOffset: number[] = [];
  @Local currentSwiperIndex: number = 0
  @Local cardsScale: number[] = [];
  @Local data: PlayListSource =
    AppStorageV2.connect(PlayListSource, APPConstants.PLAYLISTMUSIC, () => new PlayListSource([]))!
  private displayWidth: number = 0;
  private swiperMargin: number = Constants.SWIPER_MARGIN;
  @Local playingMusicList: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!
  // 添加事件回调引用
  private dataChangeCallback?: (eventData: emitter.EventData) => void;
  // 定义事件对象
  private playlistEvent: emitter.InnerEvent = {
    eventId: APPConstants.PLAYLIST_CHANGED_EVENT_ID,
    priority: emitter.EventPriority.LOW
  };

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
      this.cardsOffset.push(0);
      this.cardsScale.push(1.0);
    })
    this.calculateOffset(0);

    // 注册数据变化监听器
    this.dataChangeCallback = (eventData: emitter.EventData) => {

      const data = eventData.data as PlaylistChangeEventData;

      const action: 'add' | 'remove' = data.action;
      const item: MusicData = data.item;
      const totalCount: number = data.totalCount;

      if (action && item && totalCount !== undefined) {
        this.handleDataChange(action, item, totalCount);
      }
    };

    emitter.on(this.playlistEvent, this.dataChangeCallback);
  }

  aboutToDisappear(): void {
    // 取消注册数据变化监听器
    if (this.dataChangeCallback) {
      emitter.off(APPConstants.PLAYLIST_CHANGED_EVENT_ID);
    }
  }

  // 处理数据变化事件
  private handleDataChange(action: string, item: MusicData, totalCount: number) {
    switch (action) {
      case "add":
        this.cardsOffset.unshift(0)
        this.cardsScale.unshift(0.85)
        this.currentSwiperIndex = 0
        this.calculateOffset(this.currentSwiperIndex)
        break;

      case "remove":
        const removeIndex = this.data.getList().findIndex(i => i.id === item.id);
        if (removeIndex !== -1) {
          // 移除对应项的状态
          this.cardsOffset.splice(removeIndex, 1);
          this.cardsScale.splice(removeIndex, 1);

          // 调整当前索引（如果移除的是当前项）
          if (removeIndex === this.currentSwiperIndex) {
            this.currentSwiperIndex = Math.max(0, this.currentSwiperIndex - 1);
          } else if (removeIndex < this.currentSwiperIndex) {
            this.currentSwiperIndex -= 1;
          }
        }
        break;
    }

  }

  build() {
    Column() {
      Swiper() {
        LazyForEach(this.data, (item: MusicData) => {
          CardComponent({
            cardInfo: item,
            cardScale: this.cardsScale[this.data.getIndex(item.id)],
            totalCount: this.cardsScale.length,
            cardIndex: this.data.getIndex(item.id),
          })
        }, (item: MusicData) => item.id.toString())
      }
      .onClick(() => {
        console.log('cardscale' + this.cardsScale)
      })
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
        if (!this.isIndexValid(index)) {
          return;
        }
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
        if (!this.isIndexValid(targetIndex)) {
          return;
        }
        // 只重置非相邻卡片的缩放
        this.data.getList().forEach((_, i) => {
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
    const prev = target - 1;
    const next = target + 1;

    // 更新当前卡片
    if (this.isIndexValid(target)) {
      this.cardsOffset[target] = this.getMaxOffset(target) / 2;
      this.cardsScale[target] = 1.0;
    }

    // 更新左侧卡片
    if (this.isIndexValid(prev)) {
      this.cardsOffset[prev] = this.getMaxOffset(prev);
      this.cardsScale[prev] = 0.85;
    }

    // 更新右侧卡片
    if (this.isIndexValid(next)) {
      this.cardsOffset[next] = 0;
      this.cardsScale[next] = 0.85;
    }
  }

  isIndexValid(index: number): boolean {
    return index >= 0 && index < this.data.totalCount();
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
  @Param cardIndex: number = 0;
  @Local buttonMargin: number = 20; // 添加按钮边距变量
  @Param cardScale: number = 0.85
  @Param totalCount: number = 0
  @Local playingMusicList: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!

  @Monitor('cardScale', 'totalCount')
  oncardSaleChange() {
    this.cardWith = Constants.CARD_WIDTH * this.cardScale
    this.cardHeight = Constants.CARD_HEIGHT * this.cardScale
    this.buttonMargin = Constants.CARD_WIDTH * 0.05 * this.cardScale
    this.buttonSize = 50 * this.cardScale
    this.iconSize = 25 * this.cardScale
    console.log('cardwidth' + 'id' + this.cardInfo.id + ' width' + this.cardWith + ' scale' + this.cardScale +
      ' totalCount' + this.totalCount + ' index' + this.cardIndex)
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
    this.cardWith = Constants.CARD_WIDTH * this.cardScale
    this.cardHeight = Constants.CARD_HEIGHT * this.cardScale
    this.buttonMargin = Constants.CARD_WIDTH * 0.05 * this.cardScale
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
                this.cardWith = Constants.CARD_WIDTH * 0.9 * this.cardScale
                this.cardHeight = Constants.CARD_HEIGHT * 0.9 * this.cardScale
                this.buttonSize = 50 * 0.9 * this.cardScale
                this.iconSize = 25 * 0.9 * this.cardScale
                this.buttonMargin = this.cardWith * 0.05 * this.cardScale
              }
              if (event.type === TouchType.Up) {
                this.cardWith = Constants.CARD_WIDTH * this.cardScale
                this.cardHeight = Constants.CARD_HEIGHT * this.cardScale
                this.buttonSize = 50 * this.cardScale
                this.iconSize = 25 * this.cardScale
                this.buttonMargin = Constants.CARD_WIDTH * 0.05 * this.cardScale
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

          Image(this.playingMusicList.id === this.cardInfo.id ? $r('app.media.play_card_zanting') :
          $r('app.media.play_card_play'))
            .width(this.iconSize)
            .height(this.iconSize)
            .geometryTransition(this.cardIndex.toString(), { follow: true })
            .transition(TransitionEffect.OPACITY.animation({ duration: Constants.DURATION, curve: Curve.Friction }))
            .animation({
              curve: Curve.Friction,
              duration: Constants.DURATION
            })
            .onClick(() => {
              this.playingMusicList.isplay ? playerManager.paused() :
              playerManager.singPlay(this.playingMusicList.playList[this.playingMusicList.playIndex])
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