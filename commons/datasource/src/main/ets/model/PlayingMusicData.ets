import { MusicData } from "./MusicDataModel";

@ObservedV2
export class PlayingMusicData extends MusicData {
  // 成员变量
  @Trace id: string = '';
  @Trace title: string = '';
  @Trace singer: string = '';
  @Trace img: string = '';
  @Trace url?: string = '';
  @Trace time: number = 0;
  @Trace duration: number = 0;
  //播放和暂停
  @Trace isplay: boolean = false;
  //歌曲列表
  @Trace playIndex: number = 0
  @Trace playList: MusicData[] = [] //歌曲列表


  //播放模式
  @Trace playMode: 'loop' | 'radom' | 'single' = 'loop'
}
