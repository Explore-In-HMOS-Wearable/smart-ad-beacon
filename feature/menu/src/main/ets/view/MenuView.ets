import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager'
import { NavigationConstants } from '../constants/NavigationConstants'
import { common } from '@kit.AbilityKit'
import { MenuViewModel } from '../viewmodel/MenuViewModel'
import { MenuState } from '../state/MenuState'


@Component
export struct MenuView {
  private viewModel: MenuViewModel = new MenuViewModel()
  @State state: MenuState = MenuState.initial()

  aboutToAppear(): void {
    const uiContext = globalThis.getUIContext?.() as common.UIAbilityContext;
    this.viewModel.init(uiContext)
  }

  build() {
    NavDestination() {
      if (this.state.isLoading) {
        LoadingProgress()
      } else {
        Column() {
          Text('Menu')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 24 })

          Button() {
            Row() {
              Image($r('sys.media.ohos_ic_public_arrow_right'))
                .width(24)
                .height(24)

              Text('Settings')
                .fontSize(16)
                .fontColor(Color.Black)
                .margin({ left: 12 })
            }
            .alignItems(VerticalAlign.Center)
            .backgroundColor(Color.White)
          }
          .onClick(() => {
            NavigationManager.getInstance().pageInfos.pushPath({
              name: NavigationConstants.settings
            })
          })
          .margin({ bottom: 16 })
          .width('80%')
          .padding(12)
          .borderRadius(12)

          Button() {
            Row() {
              Image($r('sys.media.ic_grid_contacts'))
                .width(24).height(24)
              Text('Ad History')
                .fontSize(16)
                .backgroundColor(Color.White)
                .fontColor(Color.Black)
                .margin({ left: 12 })
            }
            .alignItems(VerticalAlign.Center)
          }
          .onClick(() => {
            NavigationManager.getInstance().pageInfos.pushPath({ name: NavigationConstants.adHistory })
          })
          .width('80%')
          .padding(12)
          .borderRadius(12)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#101010')
        .padding(24)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
     .hideBackButton(true)
  }
}
