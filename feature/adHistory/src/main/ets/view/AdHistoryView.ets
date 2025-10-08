import { NavigationManager } from "core/src/main/ets/navigation/NavigationManager"
import { AdModel } from "../model/AdModel"
import { AdHistoryState } from "../state/AdHistoryState"
import { AdDetailParams } from "../utils/params/AdDetailParam"
import { AdHistoryViewModel } from "../viewmodel/AdHistoryViewModel"

@Component
export struct AdHistoryView {
  private viewModel = new AdHistoryViewModel()
  @State state: AdHistoryState = AdHistoryState.initial()

  aboutToAppear() {
    this.viewModel.addListener(newState => this.state = newState)
    this.viewModel.init()
  }

  build() {
    NavDestination(){
      Column() {
        Text('History')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Center)
          .margin({ top: 12, bottom: 8 })

        if (this.state.isLoading){
          Text('Loading')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .alignSelf(ItemAlign.Center)
            .margin({ top: 12, bottom: 8 })
        }else{
          List() {
            ForEach(this.state.ads, (item: AdModel) => {
              ListItem() {
                // Kart benzeri yapı için Column kullanıyoruz
                Column() {
                  Row() {
                    Image(item.imageSrc)
                      .width('20%')
                      .aspectRatio(1)
                      .objectFit(ImageFit.Cover)
                      .borderRadius(24)
                    // Metin Bilgileri
                    Column() {
                      Text(item.title)
                        .fontSize(14)
                        .fontColor(Color.Black)
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      Text(item.description)
                        .fontSize(10)
                        .fontColor(Color.Black)
                        .margin({ top: 4 })
                    }
                    .layoutWeight(1)

                    // Sağ ok ikonu
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                      .fillColor(Color.Grey)
                      .width(16)
                      .height(16)
                  }
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.SpaceBetween)
                  .padding(8)
                  .backgroundColor(Color.White)
                  .borderRadius(12)
                }
                .margin({ top: 6, bottom: 6 })
                .onClick(() => {
                  const paramObj: AdDetailParams = {
                    ad: item
                  }

                  NavigationManager.getInstance().pageInfos.pushPath({
                    name: 'adDetail',
                    param: paramObj,
                  })
                })
              }
            }, (item: AdModel) => item.beaconId)
          }
        }
      }
      .padding(12)
      .backgroundColor(Color.Black)
    }
     .hideBackButton(true)
     .onReady((context : NavDestinationContext) => {})
  }
}
