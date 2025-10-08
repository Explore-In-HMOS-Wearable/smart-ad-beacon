import { SettingsState } from '../state/SettingsState'
import { SettingsViewModel } from '../viewmodel/SettingsViewModel'

@Component
export struct SettingsView {
  private viewModel: SettingsViewModel = new SettingsViewModel()
  @State state: SettingsState = SettingsState.initial()

  aboutToAppear(): void {
    this.viewModel.addListener((newState: SettingsState) => {
      this.state = newState
    })
    this.viewModel.init()
  }

  build() {
    NavDestination(){
      Column() {
        Text('⚙️ Settings')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 12 })

        Row() {
          Text('Automatically open bluetooth').fontSize(14).flexGrow(1)
          Toggle({
            isOn: false,
            type: ToggleType.Checkbox
          })
            .onChange((value: boolean) => {
            })
        }
        .margin({ bottom: 8 })

        // Bildirim Sesli Olsun
        Row() {
          Text('Notification').fontSize(14).flexGrow(1)
          Toggle({
            isOn: false,
            type: ToggleType.Checkbox
          })
            .onChange((value: boolean) => {
            })
        }
        .margin({ bottom: 8 })

        // Hakkında butonu
        Button('ℹ️ About')
          .fontSize(14)
          .onClick(() => {
            this.viewModel.showAbout()
          })
          .margin({ top: 16 })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
     .hideBackButton(true)
     .onReady((context: NavDestinationContext) => {})
  }
}
