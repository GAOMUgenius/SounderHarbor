import { MusicData } from "../model/MusicDataModel"


export class APPConstants {
  static readonly APPFONTFAMILY = 'SoundHarborNormalFont'
  static readonly MUSICLISTINFO: MusicData[] = [
    {
      id: '1',
      title: '归潮',
      singer: '蔡明希',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/87c9654a7b9d0392b3f4615fc6b47ba.jpg',
      url: 'guichao.mp3'
    },
    {
      id: '2',
      title: '走在小路上',
      singer: 'Badago吧嗒',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/f6d117e0feee6d0613d47acd72946eb.jpg',
      url: 'zouzaixiaolushang.mp3'
    },
    {
      id: '3',
      title: '你相信平行时空吗',
      singer: '司南',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/aa4b8ac29bb3737218d721f63b1c189.jpg',
      url: 'nixiangxinpingxingshikongma.mp3'
    }
    ,
    {
      id: '4',
      title: '有幸来过',
      singer: '要不要买菜',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/780775ec4490bc2a83655fa8f655bc8.jpg',
      url: 'youxinglaiguo.mp3'
    }
  ]
  static readonly GLOBALMUSIC: 'globalmusic'
  static readonly PLAYLISTMUSIC: 'playlistmusic'
}