import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager'
import { DashboardState } from '../state/DashboardState'
import { NavigationConstants } from '../utils/constants/NavigationConstants'
import { DashboardViewModel } from '../viewmodel/DashboardViewModel'

@Component
export struct DashboardView {

  private viewModel: DashboardViewModel = new DashboardViewModel()
  @State state: DashboardState = DashboardState.initial()

  aboutToAppear(): void {
    this.viewModel.addListener((newState: DashboardState) => {
      this.state = newState
    })
    this.viewModel.init()
  }

  onPageHide(): void {
    this.viewModel.onPageHide()
  }

  build() {
    NavDestination(){
      Stack() {
        if (this.state.latestAd) {
          Image(this.state.latestAd.imageSrc)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .onClick(() => {
              this.viewModel.onClickAd()
            })

        } else {
          Column() {
            Text('No Ad Available')
              .fontSize(14)
              .fontColor(Color.Grey)
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }

        // Alt merkezde menü butonu
        Column() {
          Button() {
            Image($r('sys.media.ohos_ic_window_menu_waterfall'))
              .width(24)
              .height(24)
          }
          .backgroundColor(Color.White)
          .onClick(() => {
            NavigationManager.getInstance().pageInfos.pushPath({ name: NavigationConstants.menu })
          })
          .margin({ bottom: 24 }) // butonun ekran kenarına yapışmaması için boşluk
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Center)

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
      .onClick(() => {
        this.viewModel.onClickAd()
      })
    }
     .hideBackButton(true)
     .onReady((context : NavDestinationContext) => {})
  }
}
