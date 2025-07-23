import { media } from '@kit.MediaKit'
import { APPConstants, MusicData, PlayingMusicData, PlayListSource } from 'datasource'
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { AppStorageV2 } from '@kit.ArkUI';
import { sessionManager } from './AvSessionManager';

class AvPlayManager {
  // 属性 ＋ 方法
  //播放器
  player: media.AVPlayer | null = null
  private context: common.ApplicationContext | undefined = undefined;
  private currentSong: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!
  private playingListSource: PlayListSource =
    AppStorageV2.connect(PlayListSource, APPConstants.PLAYLISTMUSIC, () => new PlayListSource([]))!

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
        this.currentSong.isplay = true
      } else if (state === 'completed') {
        this.nextPlay(true)
      } else if (state === 'released') {
        this.currentSong = new PlayingMusicData()
      }
    })

    //监听时间变化
    this.player.on('durationUpdate', (duration) => {
      this.currentSong.duration = duration
      sessionManager.setAVMetadata(this.currentSong.playList[this.currentSong.playIndex])
    })
    this.player.on('timeUpdate', (time) => {
      this.currentSong.time = time
      sessionManager.setAVPlayBackState()
    })
  }

  //播放歌曲 → 设置播放资源

  singPlay(song: MusicData) {
    //申请长时任务
    sessionManager.startBackgroundTask()
    sessionManager.setAVPlayBackState()
    //是否在列表
    const inList = this.currentSong.playList.some(item => item.id === song.id)
    if (inList) {
      //在列表里面
      if (this.currentSong.url === song.url) {
        this.player?.play()
        this.currentSong.isplay = true
        this.currentSong.id = song.id
      } else {
        //设置新的索引切歌
        this.currentSong.playIndex = this.currentSong.playList.findIndex(item => item.id === song.id)
        //切歌
        this.changeSong()
        this.currentSong.id = song.id
      }
    } else {
      //不在列表里
      this.currentSong.playList.unshift(song)
      this.currentSong.playIndex = 0
      //切换歌曲
      this.changeSong()
      this.playingListSource.addMusic(song)
      this.currentSong.id = song.id
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

  //暂停
  paused() {
    this.player?.pause()
    this.currentSong.isplay = false
    sessionManager.setAVPlayBackState()
  }

  //上一首
  prevPlay() {
    if (this.currentSong.playMode === 'radom') {
      //随机
      this.currentSong.playIndex = Math.floor(Math.random() * this.currentSong.playList.length)

    } else {
      this.currentSong.playIndex--
      if (this.currentSong.playIndex < 0) {
        //去最后一首歌
        this.currentSong.playIndex = this.currentSong.playList.length - 1
      }
    }
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  //下一首: 根据播放模式计算索引
  //真的重复播放 播放模式为single 并且播放器自动下一首  completed  传入一个参数表示是自动的
  //随机 计算随机索引
  //列表 ++
  nextPlay(auto?: boolean) {
    if (this.currentSong.playMode === 'single' && auto) {
      //真的重复 索引不变
      this.currentSong.playIndex = this.currentSong.playIndex

    } else if (this.currentSong.playMode === 'radom') {
      //随机
      this.currentSong.playIndex = Math.floor(Math.random() * this.currentSong.playList.length)
    } else {
      //列表
      this.currentSong.playIndex++
      if (this.currentSong.playIndex > this.currentSong.playList.length - 1) {
        //去第一首歌
        this.currentSong.playIndex = 0
      }
    }

    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  deleteSong(id: string) {
    let index = this.currentSong.playList.findIndex(item => {
      // 确保item存在且有id属性（避免空指针错误）
      return item && item.id === id;
    });
    if (index === this.currentSong.playIndex) {
      this.currentSong.playList.splice(index, 1)
      if (this.currentSong.playList.length !== 0) {
        this.nextPlay()
      } else {
        this.paused()
      }
    } else {
      this.currentSong.playList.splice(index, 1)
    }
  }

  //释放播放器和播放的数据
  async release() {
    await this.player?.release()
  }
}

export const playerManager: AvPlayManager = new AvPlayManager()