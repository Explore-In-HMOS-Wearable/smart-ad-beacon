import { BleManager, IBeaconData } from 'core/src/main/ets/bluetooth/BleManager';
import { LogManager } from 'core/src/main/ets/logger/LogManager';
import { NotificationManager } from 'core/src/main/ets/notification/NotificationManager';
import { DashboardState } from '../state/DashboardState';
import { DashboardHelper } from '../utils/helper/DashboardHelper';
import { StorageManager } from 'core/src/main/ets/storage/StorageManager'
import { AdModel } from '../model/AdModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager';
import { NavigationConstants } from '../utils/constants/NavigationConstants';
import { AdDetailParams } from '../utils/params/AdDetailParam'
import { Duration } from 'core/src/main/ets/base/DurationModel';
import { CacheConstants } from '../utils/constants/CacheConstants';
import { AdListModel } from '../model/AdListModel';
import { BackgroundManager } from 'core/src/main/ets/background/BackgroundManager';
import { common } from '@kit.AbilityKit';


export class DashboardViewModel {
  private _state: DashboardState = DashboardState.initial()
  private listeners: Array<(state: DashboardState) => void> = []
  private readonly TAG: string = 'DashboardViewModel';
  context = getContext(this) as common.UIAbilityContext;

  get state(): DashboardState {
    return this._state
  }

  set state(newState: DashboardState) {
    this._state = newState
    this.notifyListeners()
  }

  addListener(listener: (state: DashboardState) => void) {
    this.listeners.push(listener)
  }

  private notifyListeners() {
    this.listeners.forEach(listener => listener(this._state))
  }

  async init(): Promise<void> {
    this.state = this.state.with({isLoading: true})
    const ble = await BleManager.getInstance()
    const notify = await NotificationManager.getInstance()
    const storage = await StorageManager.getInstance()

    ble.setOnBeaconFoundCallback(async (beaconData: IBeaconData) => {
      if (beaconData.uuid != null && beaconData.major != null && beaconData.minor != null){
        const ad: AdModel | undefined = DashboardHelper.adList.find(ad => ad.beaconId === beaconData.uuid && ad.major === beaconData.major && ad.minor === beaconData.minor);
        const distance = ble.measureDistance(beaconData.rssi,beaconData.txPower)
        this.state = this.state.with({distance: distance})

        let data = await storage.getModelWithExpiry(CacheConstants.seenAds,AdListModel.fromJson)
        let historyData = await storage.getModelWithExpiry(CacheConstants.adHistory,AdListModel.fromJson)
        const item = data?.adList.find(item => item.beaconId === ad?.beaconId && item.major === ad.major && item.minor === ad.minor)
        LogManager.info(this.TAG,`bulunan item: ${item?.beaconId}`)

        if (this.state.latestAd === null || this.state.latestAd === undefined){
          this.state = this.state.with({latestAd: ad})
        }

        if (ad != null && item == null){
          LogManager.info(this.TAG,'yeni reklam bulundu')
          await notify.publishSimpleNotification(ad!.title,ad!.description)
          this.state = this.state.with({latestAd: ad})
          let list = data?.adList ?? []
          let historyList = historyData?.adList ?? []
          list?.push(ad)
          historyList?.push(ad)
          const newList = new AdListModel(list)
          const newHistoryList = new AdListModel(historyList)
          await storage.saveModelWithExpiry(CacheConstants.seenAds,newList,Duration.minutes(2))
          await storage.saveModelWithExpiry(CacheConstants.adHistory,newHistoryList,Duration.days(30))
        }
      }
    })

    await ble.startScan()
      .then((r) => {
      this.state = this.state.with({isScanning: true})
    }).catch((e: BusinessError) => {
      this.state = this.state.with({isScanning: false,error: `${e}`})
      })

    BackgroundManager.startBeaconBackgroundTask(this.context)
    this.state = this.state.with({isLoading: false})
  }

  async onPageHide() {
  }

  onClickAd(){
    const latestAd = this.state.latestAd
    if (latestAd != null){

      const param: AdDetailParams = {
        ad: latestAd
      }

      NavigationManager.getInstance().pageInfos.pushPathByName(NavigationConstants.adDetail,param)

    }
  }

}
