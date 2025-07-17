import { CardInfo } from "../model/CardModel";

export default class Constants {
  // 同时显示的卡片数量
  static readonly MAX_CARDS = 3
  // 圆形轨迹参数
  // 圆形轨迹半径
  static readonly CIRCLE_RADIUS = 250
  // 圆心X坐标
  static readonly CIRCLE_CENTER_X = 300
  // 圆心Y坐标
  static readonly CIRCLE_CENTER_Y = 150
  // 显示角度范围
  static readonly TOTAL_ANGLE = 150
  // 每张卡片的角度间隔
  static readonly CARD_ANGLE = this.TOTAL_ANGLE / (this.MAX_CARDS + 1)
  static readonly CARD_LIST_INFO: CardInfo[] = [
    {
      id: "1",
      title: "PDA",
      introduce: "限定版",
      singer: "昭宥",
      rating: 4.9,
      price: "¥28",
      img: "https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/swiper_test_img_01.jpg"
    },
    {
      id: "2",
      title: "未·LIVE",
      introduce: "歌曲重制版",
      singer: "张杰",
      rating: 4.8,
      price: "¥198",
      img: "https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/swiper_test_img_02.jpg"
    },
    {
      id: "3",
      title: "精气神",
      introduce: "极简美学",
      singer: "梁博",
      rating: 4.6,
      price: "¥85",
      img: "https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/swiper_test_img_03.jpg"
    },
    {
      id: "4",
      title: "范特西",
      introduce: "世纪里程碑",
      singer: "周杰伦",
      rating: 5.0,
      price: "¥68",
      img: "https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/swiper_test_img_04.jpg"
    },
    {
      id: "5",
      title: "万能青年旅店",
      introduce: "独立摇滚",
      singer: "万能青年旅店",
      rating: 4.9,
      price: "¥12",
      img: "https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/swiper_test_img_05.jpg"
    },
    {
      id: "6",
      title: "洄游",
      introduce: "后摇史诗",
      singer: "陈粒",
      rating: 4.7,
      price: "¥96",
      img: "https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/swiper_test_img_06.jpg"
    }
  ];
}