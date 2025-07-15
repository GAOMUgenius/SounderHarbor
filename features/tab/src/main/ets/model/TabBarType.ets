export interface TabBarTypeData {
  id: TabBarType
  title: string
  icon: ResourceStr
}

export enum TabBarType {
  HOME = 0,
  DISCOVERY,
  PLAY,
  MINE
}

export const tabBarTypeData: TabBarTypeData[] = [
  {
    id: TabBarType.HOME,
    title: 'Home',
    icon: $r('app.media.tab_icon_home')
  },
  {
    id: TabBarType.DISCOVERY,
    title: 'Disc',
    icon: $r('app.media.tab_icon_discovery')
  },
  {
    id: TabBarType.PLAY,
    title: 'Play',
    icon: $r('app.media.tab_icon_play')
  },
  {
    id: TabBarType.MINE,
    title: 'Mine',
    icon: $r('app.media.tab_icon_mine')
  }
]