import { AdDetailState } from '../state/AdDetailState'
import { AdDetailViewModel } from '../viewmodel/AdDetailViewModel'
import { router } from '@kit.ArkUI'
import { AdDetailParams } from '../utils/params/AdDetailParam'
import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager'
import { NavigationConstants } from '../utils/constants/NavigationConstants'

@Component
export struct AdDetailView {
  private viewModel: AdDetailViewModel = new AdDetailViewModel()
  @State state: AdDetailState = AdDetailState.initial()

  aboutToAppear(): void {
    this.viewModel.addListener((newState: AdDetailState) => {
      this.state = newState
    })
    this.viewModel.init()
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          // Reklam görseli
          Image(this.state.adDetail?.ad.imageSrc)
            .width('100%')
            .aspectRatio(1)
            .objectFit(ImageFit.Cover)
            .borderRadius(24)
            .margin({ bottom: 16,top: 16 })

          // Başlık
          Text(this.state.adDetail?.ad.title ?? 'No Title')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 10 })

          // Açıklama
          Text(this.state.adDetail?.ad.description ?? 'No Description')
            .fontSize(14)
            .fontColor(Color.White)
            .margin({ bottom: 10 })

          // Kod varsa
          if (this.state.adDetail?.ad.code) {
            Text('Discount Code: ' + this.state.adDetail.ad.code)
              .fontSize(14)
              .fontColor(Color.Yellow)
              .margin({ bottom: 10 })
          }
        }
        .padding(16)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .hideBackButton(true)
    .onBackPressed(() => {
      NavigationManager.getInstance().pageInfos.pushPath({name: NavigationConstants.dashboard})
      return true
    })
    .onReady((context: NavDestinationContext) => {
      const params = context.pathInfo.param as AdDetailParams;
      this.viewModel.setParam(params)
    })
  }
}
