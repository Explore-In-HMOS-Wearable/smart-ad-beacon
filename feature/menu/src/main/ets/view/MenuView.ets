import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager'
import { NavigationConstants } from '../constants/NavigationConstants'

@Component
export struct MenuView {
  build() {
    NavDestination(){
      Column() {
        Text('Menu')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ bottom: 24 })

        // Settings Button
        Button() {
          Row() {
            Image($r('sys.media.ohos_ic_public_arrow_right'))
              .width(24).height(24)
            Text('Settings')
              .fontSize(16)
              .fontColor(Color.Black)
              .margin({ left: 12 })
          }
          .alignItems(VerticalAlign.Center)
        }
        .onClick(() => {
          NavigationManager.getInstance().pageInfos.pushPath({ name: NavigationConstants.settings })
        })
        .margin({ bottom: 16 })
        .width('80%')
        .backgroundColor(Color.White)
        .padding(12)
        .borderRadius(12)

        // Ad History Button
        Button() {
          Row() {
            Image($r('sys.media.ic_grid_contacts')) // ya da istediğin başka bir icon
              .width(24).height(24)
            Text('Ad History')
              .fontSize(16)
              .fontColor(Color.Black)
              .margin({ left: 12 })
          }
          .alignItems(VerticalAlign.Center)
        }
        .onClick(() => {
          NavigationManager.getInstance().pageInfos.pushPath({ name: NavigationConstants.adHistory })
        })
        .width('80%')
        .backgroundColor(Color.White)
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
     .hideBackButton(true)
     .onReady((context : NavDestinationContext) => {})
  }
}
