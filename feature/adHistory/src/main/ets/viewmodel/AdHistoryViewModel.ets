import { AdModel } from '../model/AdModel';
import { AdHistoryState } from '../state/AdHistoryState';
import { BleManager, IBeaconData } from 'core/src/main/ets/bluetooth/BleManager'
import { NotificationManager } from 'core/src/main/ets/notification/NotificationManager';
import StorageManager from 'core/src/main/ets/storage/StorageManager';
import { LogManager } from 'core/src/main/ets/logger/LogManager';
import { AdHistoryHelper } from '../utils/helper/AdHistoryHelper';
import { CacheConstants } from '../utils/constants/CacheConstants';
import { AdListModel } from '../model/AdListModel';
import { Duration } from 'core/src/main/ets/base/DurationModel';
import { AdDetailParams } from '../utils/params/AdDetailParam';
import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager';
import { NavigationConstants } from '../utils/constants/NavigationConstants';

export class AdHistoryViewModel {
  private _state: AdHistoryState = AdHistoryState.initial();
  private listeners: Array<(state: AdHistoryState) => void> = [];
  TAG = 'AdHistortyViewModel'

  get state(): AdHistoryState {
    return this._state;
  }

  set state(newState: AdHistoryState) {
    this._state = newState;
    this.notifyListeners();
  }

  addListener(listener: (state: AdHistoryState) => void) {
    this.listeners.push(listener);
  }

  private notifyListeners() {
    this.listeners.forEach(listener => listener(this._state));
  }

  async init() {
    this.state = this.state.with({isLoading: true})
    const storage = await StorageManager.getInstance()
    let historyData = await storage.getModelWithExpiry(CacheConstants.adHistory, AdListModel.fromJson)
    let historyDataList = historyData?.adList ?? []
    LogManager.info(this.TAG,`gelen data list length: ${historyDataList.length}`)
    this.state = this.state.with({ ads: historyDataList, isLoading: false })

    const ble = await BleManager.getInstance()
    const notify = await NotificationManager.getInstance()

    ble.setOnBeaconFoundCallback(async (beaconData: IBeaconData) => {
      if (beaconData.uuid != null && beaconData.major != null && beaconData.minor != null) {
        const ad: AdModel | undefined =
          AdHistoryHelper.adList.find(ad => ad.beaconId === beaconData.uuid && ad.major === beaconData.major &&
            ad.minor === beaconData.minor);

        let data = await storage.getModelWithExpiry(CacheConstants.seenAds, AdListModel.fromJson)
        let historyData = await storage.getModelWithExpiry(CacheConstants.adHistory, AdListModel.fromJson)
        const item = data?.adList.find(item => item.beaconId === ad?.beaconId && item.major === ad.major &&
          item.minor === ad.minor)
        LogManager.info(this.TAG, `bulunan item: ${item?.beaconId}`)

        if (ad != null && item == null) {
          LogManager.info(this.TAG, 'yeni reklam bulundu')
          await notify.publishSimpleNotification(ad!.title, ad!.description)
          let list = data?.adList ?? []
          let historyList = historyData?.adList ?? []
          list?.push(ad)
          historyList.push(ad)
          const newList = new AdListModel(list)
          const newHistoryList = new AdListModel(historyList)
          await storage.saveModelWithExpiry(CacheConstants.seenAds, newList, Duration.minutes(2))
          await storage.saveModelWithExpiry(CacheConstants.adHistory, newHistoryList, Duration.days(30))
          this.state = this.state.with({ ads: historyList })
        }
      }
    })
  }

  onClickAd(ad: AdModel) {

    const param: AdDetailParams = { ad: ad }
    NavigationManager.getInstance().pageInfos.pushPathByName(NavigationConstants.adDetail, param)
  }
}
