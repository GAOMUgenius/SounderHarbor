import { HostMusicData } from "../model/HostMusicModel"

export class Constants {
  static readonly RECOMMEND_SWIPERBANNER_SWIPERDATALISTINFO: string[] = [
    'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/home_recommend_swiper_03.png',
    'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/home_recommend_swiper_02.png',
    'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/home_recommend_swiper_01.png'
  ]
  static readonly RECOMMEND_HOSTMUSIC_HOSTMUSICDATALISTINFO: HostMusicData[] = [
    {
      id: '1',
      title: '归潮',
      singer: '蔡明希',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951167156560252.jpg'
    },
    {
      id: '2',
      title: '走在小路上',
      singer: 'Badago吧嗒',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951170498022745.jpg'
    },
    {
      id: '3',
      title: '你相信平行时空吗',
      singer: '司南',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951167165881731.jpg'
    }
  ]
}