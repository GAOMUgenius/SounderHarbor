import { avSession } from '@kit.AVSessionKit'
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager'
import { wantAgent } from '@kit.AbilityKit';
import { APPConstants, MusicData, PlayingMusicData } from 'datasource';
import { AppStorageV2 } from '@kit.ArkUI';
import { playerManager } from './AvPlayerManager';

class AvSessionManager {
  session: avSession.AVSession | null = null
  playingMusic: PlayingMusicData =
    AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())!

  async init(context: Context) {
    this.session = await avSession.createAVSession(context, 'bgPlay', 'audio')
    this.registerEvent()
  }

  //申请长时任务
  async startBackgroundTask() {

    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: "com.example.soundharbor",
          abilityName: "EmtryAbility"
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
    }
    const want = await wantAgent.getWantAgent(wantAgentInfo)
    await backgroundTaskManager.startBackgroundRunning(getContext(),
      backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,
      want)
  }

  //设置元数据
  setAVMetadata(song: MusicData) {
    this.session?.setAVMetadata({
      assetId: song.id,
      title: song.title,
      mediaImage: song.img,
      artist: song.singer,
      duration: this.playingMusic.duration
    })
  }

  //设置播放状态
  setAVPlayBackState() {
    this.session?.setAVPlaybackState({
      state: this.playingMusic.isplay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
      avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      speed: 1,
      position: {
        elapsedTime: this.playingMusic.time,
        updateTime: new Date().getTime()
      },
      duration: this.playingMusic.duration
    })
  }

  //注册事件
  registerEvent() {
    this.session?.on('play', () => {
      playerManager.singPlay(this.playingMusic.playList[this.playingMusic.playIndex])
    })
    this.session?.on('pause', () => {
      playerManager.paused()
    })
    this.session?.on('playPrevious', () => {
      playerManager.prevPlay()
    })
    this.session?.on('playNext', () => {
      playerManager.nextPlay()
    })
    this.session?.on('seek', (value: number) => {
      playerManager.seekPlay(value)
    })

    this.session?.activate()
  }

  //注销会话
  async destroy() {
    await this.session?.destroy()
  }
}


export const sessionManager: AvSessionManager = new AvSessionManager()