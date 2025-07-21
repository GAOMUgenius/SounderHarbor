import { APPConstants, PlayingMusicData } from "datasource";
import { playerManager } from "utils";
import { AppStorageV2 } from "@kit.ArkUI";

function generateAudioBars(totalCount: number[]): number[] {
  for (let i = 0; i < 30; i++) {
    totalCount.push(0.3 + Math.random() * 0.6)
  }
  return totalCount
}

function getCurrentBarIndex(
  currentTime: number,
  totalDuration: number,
  barCount: number
): number {
  if (totalDuration === 0) {
    return 0;
  }
  const progress = currentTime / totalDuration; // 0-1进度比例
  return Math.min(Math.floor(progress * barCount), barCount - 1);
}


@ComponentV2
export struct AudioBarProgress {
  // 当前播放时间（外部传入，随播放更新）
  @Param currentTime: number = 0
  // 音频总时长（外部传入）
  @Param totalDuration: number = 0
  // 柱状图数据（预生成的高度数组）
  @Local audioBars: number[] = generateAudioBars([])
  // 柱子总数
  private barCount: number = 30
  @Local playingMusicData: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!

  build() {
    Row() {
      // 遍历生成柱子
      ForEach(this.audioBars, (height: number, index: number) => {
        // 柱子样式：当前进度前的柱子用高亮色，之后用默认色
        Column()
          .width(5) // 平均分配宽度（100% / barCount）
          .height(`${height * 100}%`) // 高度由音频数据决定（0-100%）
          .backgroundColor(index <= getCurrentBarIndex(this.currentTime, this.totalDuration, this.barCount) ?
            '#C4F2C7D1' : '#CCCCCC')
          .borderRadius(2)
          .margin({ left: 1, right: 1 })
          .onClick(() => {
            this.playingMusicData.time = index / 30 * this.totalDuration
            playerManager.seekPlay(this.playingMusicData.time)
          })
      })
    }
    .height(50) // 柱状图总高度
    .layoutWeight(1)
    .alignItems(VerticalAlign.Center) // 柱子底部对齐（模拟音频波形）
    .justifyContent(FlexAlign.Center)
  }
}