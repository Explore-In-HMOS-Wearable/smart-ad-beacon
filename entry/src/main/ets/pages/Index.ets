import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager'
import { DashboardView } from 'dashboard/src/main/ets/view/DashboardView'
import { SplashView } from 'splash/src/main/ets/view/SplashView'
import { SettingsView } from 'settings/src/main/ets/view/SettingsView'
import { AdHistoryView } from 'adhistory/src/main/ets/view/AdHistoryView'
import { MenuView } from 'menu'
import { AdDetailView } from 'addetail/src/main/ets/view/AdDetailView'

@Entry
@Component
struct Index {
  @Builder
  routeMap(name: string) {
    if (name === 'splash') {
      SplashView()
    } else if (name === 'dashboard') {
      DashboardView()
    } else if (name === 'settings') {
      SettingsView()
    } else if (name === 'adHistory') {
      AdHistoryView()
    } else if (name === 'adDetail') {
      AdDetailView()
    } else if (name === 'menu') {
      MenuView()
    } else {
      SplashView()
    }
  }

  build() {
    Navigation(NavigationManager.getInstance().pageInfos) {
      SplashView()
    }
    .navDestination(this.routeMap)
    .ignoreLayoutSafeArea()
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
  }
}

