import { media } from '@kit.MediaKit'
import { PlayingMusicData } from 'datasource'
import { common } from '@kit.AbilityKit';

class AvPlayManager {
  // 属性 ＋ 方法
  //播放器
  player: media.AVPlayer | null = null
  private context: common.UIAbilityContext | undefined = undefined;

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
  }

  //播放歌曲 → 设置播放资源
  async singPlay(song: PlayingMusicData) {
    // 在业务函数中（示例工程函数名为avSetupURL）：
    // this.context = getContext(this) as common.UIAbilityContext
    // // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址。
    // // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度。
    // let fileDescriptor = await this.context.resourceManager.getRawFd(song.url)
    // let avFileDescriptor: media.AVFileDescriptor =
    //   { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    // // 为fdSrc赋值触发initialized状态机上报。
    // this.player!.fdSrc = avFileDescriptor;
    this.player!.url = song.url
  }
}

export const playerManager: AvPlayManager = new AvPlayManager()