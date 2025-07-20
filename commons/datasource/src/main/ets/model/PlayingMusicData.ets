import { MusicData } from "../../../../Index";

@ObservedV2
export class PlayingMusicData implements MusicData {
  // 单例实例的静态引用
  private static instance: PlayingMusicData;
  // 成员变量
  @Trace id: string = '';
  @Trace title: string = '';
  @Trace singer: string = '';
  @Trace img: string = '';
  @Trace url?: string = '';
  @Trace time: number = 0;
  @Trace duration: number = 0;
  @Trace isplay: boolean = false;

  // 私有构造函数防止外部实例化
  private constructor() {
  }

  // 全局访问点
  public static getInstance(): PlayingMusicData {
    if (!PlayingMusicData.instance) {
      PlayingMusicData.instance = new PlayingMusicData();
    }
    return PlayingMusicData.instance;
  }
}

export const playingMusicData = PlayingMusicData.getInstance();