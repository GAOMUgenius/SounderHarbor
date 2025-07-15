import { HMNavigation, HMRouter, HMRouterMgr } from '@hadss/hmrouter'

@HMRouter({pageUrl: "MainPage"})
@ComponentV2
export struct MainPage {
  aboutToAppear(): void {
    HMRouterMgr.push({ pageUrl: "TabComponent"})
  }
  build() {
    Text('MainPage')
  }
}