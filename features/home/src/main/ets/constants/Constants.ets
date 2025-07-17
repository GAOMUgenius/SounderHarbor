import { HostMusicData } from "../model/HostMusicModel"
import { RecommendMusicListData } from "../model/RecommendMusicListModel"

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
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/87c9654a7b9d0392b3f4615fc6b47ba.jpg'
    },
    {
      id: '2',
      title: '走在小路上',
      singer: 'Badago吧嗒',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/f6d117e0feee6d0613d47acd72946eb.jpg'
    },
    {
      id: '3',
      title: '你相信平行时空吗',
      singer: '司南',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/aa4b8ac29bb3737218d721f63b1c189.jpg'
    }
    ,
    {
      id: '4',
      title: '有幸来过',
      singer: '要不要买菜',
      img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/780775ec4490bc2a83655fa8f655bc8.jpg'
    }
  ]
  static readonly RECOMMEND_MUSICLIST_RECOMMENDMUSICLISTINGO: RecommendMusicListData[] = [
    {
      list_id: '1',
      list_title: '你喜欢的歌 我听上万遍',
      list_user_name: 'TINY',
      list_user_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951169247582185.jpg',
      list_introduce: '成年人感情世界里的潜规则：不主动就是答案，没有回应就等于拒绝。这世界上没有人会忙到一天，却不回复你的消息',
      list_share: 16854,
      list_comments: 62,
      list_collection: 40079,
      list_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951170069527103.jpg',
      list_music: []
    },
    {
      list_id: '2',
      list_title: '触电节奏一秒倾心~',
      list_user_name: '续写不了我们故事',
      list_user_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951171270947779.jpg',
      list_introduce: '为保持歌单质量，会持续删除和更新歌曲，都是不烂大街的电音好曲，高潮部分有惊喜！带上耳机会起飞哦~（更新歌曲在前十首随机排布）',
      list_share: 4542,
      list_comments: 17,
      list_collection: 6845,
      list_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951170496435891.jpg',
      list_music: []
    },
    {
      list_id: '3',
      list_title: '百听不厌的英文歌',
      list_user_name: '旅行日记',
      list_user_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951169717630534.jpg',
      list_introduce: '谢谢大家的收藏，然叔在这里谢谢大家了。建议随机播放！！！大家有好听的英文歌都可以私信给我，好听的我也会放到歌单里。',
      list_share: 2534,
      list_comments: 75,
      list_collection: 5645,
      list_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951166056299188.jpg',
      list_music: []
    },
    {
      list_id: '4',
      list_title: '和crush一起听的甜甜小恋曲',
      list_user_name: '凌晨一点的缅因猫',
      list_user_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951171455159407.jpg',
      list_introduce: '把期望降低，所有遇见的都是礼物~',
      list_share: 426,
      list_comments: 454,
      list_collection: 2422,
      list_img: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/109951171353635370.jpg',
      list_music: []
    }
  ]
}