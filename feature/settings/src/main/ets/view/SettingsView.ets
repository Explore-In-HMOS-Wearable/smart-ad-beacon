import { LogManager } from 'core/src/main/ets/logger/LogManager'
import { SettingsState } from '../state/SettingsState'
import { SettingsViewModel } from '../viewmodel/SettingsViewModel'

@Component
export struct SettingsView {

  private viewModel: SettingsViewModel = new SettingsViewModel()
  @State state: SettingsState = SettingsState.initial()

  TAG : string = 'SettingsView'

  aboutToAppear(): void {
    this.viewModel.addListener((newState: SettingsState) => {
      this.state = newState
    })

    this.viewModel.init()
  }

  build() {
    NavDestination() {
      if (this.state.isLoading) {
        LoadingProgress()
      } else {
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
                LogManager.info(this.TAG, `toggled: ${value}`)
              })
          }
          .margin({ bottom: 8 })

          Row() {
            Text('Notification').fontSize(14).flexGrow(1)
            Toggle({
              isOn: false,
              type: ToggleType.Checkbox
            })
              .onChange((value: boolean) => {
                LogManager.info(this.TAG, `toggled: ${value}`)
              })
          }
          .margin({ bottom: 8 })
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.Center)
      }
    }
     .hideBackButton(true)
  }
}
