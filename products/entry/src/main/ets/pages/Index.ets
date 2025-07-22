import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter'
import { AppStorageV2, AttributeUpdater, font } from '@kit.ArkUI';
import { APPConstants, PlayingMusicData, PlayListSource } from 'datasource';

AppStorageV2.connect(PlayingMusicData, APPConstants.GLOBALMUSIC, () => new PlayingMusicData())
AppStorageV2.connect(PlayListSource, APPConstants.PLAYLISTMUSIC, () => new PlayListSource([]))

@Entry
@ComponentV2
struct Index {
  modifier: MyNavModifier = new MyNavModifier();

  aboutToAppear(): void {

  }

  onPageShow(): void {
    font.registerFont({
      familyName: APPConstants.APPFONTFAMILY,
      familySrc: $rawfile('No.15-ShangShouRunHeiTi-2.ttf')
    })
  }

  build() {
    Column() {
      HMNavigation({
        navigationId: "mainNavigation",
        homePageUrl: "TabComponent",
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}

class MyNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.hideNavBar(true);
  }
}