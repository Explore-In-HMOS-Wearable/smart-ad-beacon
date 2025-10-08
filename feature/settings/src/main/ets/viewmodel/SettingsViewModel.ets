import { SettingsState } from '../state/SettingsState'
import { BleManager, IBeaconData } from 'core/src/main/ets/bluetooth/BleManager'
import { NotificationManager } from 'core/src/main/ets/notification/NotificationManager'
import StorageManager from 'core/src/main/ets/storage/StorageManager'
import { LogManager } from 'core/src/main/ets/logger/LogManager'
import { AdModel } from '../model/AdModel'
import { SettingsHelper } from '../utils/helper/SettingsHelper'
import { CacheConstants } from '../utils/constants/CacheConstants'
import { AdListModel } from '../model/AdListModel'
import { Duration } from 'core/src/main/ets/base/DurationModel'

export class SettingsViewModel {
  private _state: SettingsState = SettingsState.initial()
  private listeners: Array<(state: SettingsState) => void> = []
  TAG = "SettingsViewModel"

  get state(): SettingsState {
    return this._state
  }

  set state(newState: SettingsState) {
    this._state = newState
    this.notifyListeners()
  }

  addListener(listener: (state: SettingsState) => void) {
    this.listeners.push(listener)
  }

  private notifyListeners() {
    this.listeners.forEach(listener => listener(this._state))
  }

  async init() {
    // Eğer persist ediyorsan buradan oku
    this.state = this.state.with({
      autoEnableBluetooth: true,
      soundEnabled: false
    })

    const ble = await BleManager.getInstance()
    const notify = await NotificationManager.getInstance()
    const storage = await StorageManager.getInstance()

    ble.setOnBeaconFoundCallback(async (beaconData: IBeaconData) => {
      if (beaconData.uuid != null && beaconData.major != null && beaconData.minor != null){
        const ad: AdModel | undefined = SettingsHelper.adList.find(ad => ad.beaconId === beaconData.uuid && ad.major === beaconData.major && ad.minor === beaconData.minor);

        let data = await storage.getModelWithExpiry(CacheConstants.seenAds,AdListModel.fromJson)
        let historyData = await storage.getModelWithExpiry(CacheConstants.adHistory,AdListModel.fromJson)
        const item = data?.adList.find(item => item.beaconId === ad?.beaconId && item.major === ad.major && item.minor === ad.minor)
        LogManager.info(this.TAG,`bulunan item: ${item?.beaconId}`)

        if (ad != null && item == null){
          LogManager.info(this.TAG,'yeni reklam bulundu')
          await notify.publishSimpleNotification(ad!.title,ad!.description)
          let list = data?.adList ?? []
          let historyList = historyData?.adList ?? []
          list?.push(ad)
          historyList.push(ad)
          const newList = new AdListModel(list)
          const newHistoryList = new AdListModel(historyList)
          await storage.saveModelWithExpiry(CacheConstants.seenAds,newList,Duration.minutes(2))
          await storage.saveModelWithExpiry(CacheConstants.adHistory,newHistoryList,Duration.days(30))
        }
      }
    })


  }

  setBluetoothAuto(value: boolean) {
    this.state = this.state.with({ autoEnableBluetooth: value })
    // storage.save('autoBluetooth', value)
  }

  setSoundEnabled(value: boolean) {
    this.state = this.state.with({ soundEnabled: value })
    // storage.save('soundEnabled', value)
  }

  showAbout() {
    // modal ya da navigation
    console.info('Uygulama Hakkında')
  }
}
