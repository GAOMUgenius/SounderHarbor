import { HMParamType, HMRouter } from '@hadss/hmrouter'
import { DiscoveryPage } from 'discovery';
import { HomePage } from 'home';
import { PlayPage } from 'play';
import { TabBarType } from '../model/TabBarType';
import { CustomTabBar } from './CustomTabBar';
import { PlayMusicComponent } from './PlayMusicComponent';

@HMRouter({ pageUrl: "TabComponent" })
@ComponentV2
export struct TabComponent {
  @Local param: HMParamType | null = null;
  @Provider('currentIndex') currentIndex: TabBarType = TabBarType.HOME

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Tabs({ index: this.currentIndex }) {
        TabContent() {
          HomePage()
        }

        TabContent() {
          DiscoveryPage()
        }

        TabContent() {
          PlayPage()
        }

        TabContent() {
          Text('Mine')
        }
      }
      .layoutWeight(1)
      .width('100%')
      .barHeight(0)
      .scrollable(false)
      .onChange((index) => {
        this.currentIndex = index;
      })

      PlayMusicComponent()


      CustomTabBar()
    }
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      repeating: false, // 渐变颜色是否重复
      colors: [[0xd4e9ee, 0.0], [0xf5eaee, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .width('100%')
  }
}