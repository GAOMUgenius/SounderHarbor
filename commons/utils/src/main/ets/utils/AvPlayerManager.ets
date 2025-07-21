import { media } from '@kit.MediaKit'
import { APPConstants, MusicData, PlayingMusicData } from 'datasource'
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { AppStorageV2 } from '@kit.ArkUI';

class AvPlayManager {
  // 属性 ＋ 方法
  //播放器
  player: media.AVPlayer | null = null
  private context: common.ApplicationContext | undefined = undefined;
  private currentSong: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!

  //定义方法 创建播放器 + 监听播放器的状态变化
  async init() {
    if (!this.player) {
      this.player = await media.createAVPlayer()
    }

    this.player.on('stateChange', (state) => {
      if (state === 'initialized') {
        this.player?.prepare()
      } else if (state === 'prepared') {
        this.player?.play()
      }
    })

    //监听时间变化
    this.player.on('durationUpdate', (duration) => {
      this.currentSong.duration = duration
    })
    this.player.on('timeUpdate', (time) => {
      this.currentSong.time = time
    })
  }

  //播放歌曲 → 设置播放资源

  singPlay(song: MusicData) {

    //是否在列表
    const inList = this.currentSong.playList.some(item => item.id === song.id)
    if (inList) {
      //在列表里面
      if (this.currentSong.id === song.id) {
        this.player?.play()
      } else {
        //设置新的索引切歌
        this.currentSong.playIndex = this.currentSong.playList.findIndex(item => item.id === song.id)
        //切歌
        this.changeSong()
      }
    } else {
      //不在列表里
      this.currentSong.playList.unshift(song)
      this.currentSong.playIndex = 0
      //切换歌曲
      this.changeSong()
    }
  }

  //切换歌曲
  async changeSong() {
    await this.player?.reset()
    this.currentSong.duration = 0
    this.currentSong.time = 0
    this.currentSong.img = this.currentSong.playList[this.currentSong.playIndex].img
    this.currentSong.title = this.currentSong.playList[this.currentSong.playIndex].title
    this.currentSong.singer = this.currentSong.playList[this.currentSong.playIndex].singer
    this.currentSong.url = this.currentSong.playList[this.currentSong.playIndex].url
    this.context = getContext(this) as common.ApplicationContext
    try {
      this.context.resourceManager.getRawFd(this.currentSong.url,
        (error: BusinessError, value: resourceManager.RawFileDescriptor) => {
          if (error != null) {
            console.error(`callback getRawFd failed error code: ${error.code}, message: ${error.message}.`);
          } else {
            let fd = value.fd;
            let offset = value.offset;
            let length = value.length;
            let avFileDescriptor: media.AVFileDescriptor =
              { fd: fd, offset: offset, length: length };
            this.player!.fdSrc = avFileDescriptor;
          }
        });
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(`callback getRawFd failed, error code: ${code}, message: ${message}.`);
    }
  }

  //跳转进度
  seekPlay(value: number) {
    this.player?.seek(value)
  }
}

export const playerManager: AvPlayManager = new AvPlayManager()