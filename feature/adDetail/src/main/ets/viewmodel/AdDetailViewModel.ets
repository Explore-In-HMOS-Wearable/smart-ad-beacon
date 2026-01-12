import { AdDetailState } from '../state/AdDetailState';
import { BleManager, IBeaconData } from 'core/src/main/ets/bluetooth/BleManager'
import { NotificationManager } from 'core/src/main/ets/notification/NotificationManager'
import { LogManager } from 'core/src/main/ets/logger/LogManager'
import { StorageManager } from 'core/src/main/ets/storage/StorageManager'
import { AdDetailHelper } from '../utils/helper/AdDetailHelper';
import { AdModel } from '../model/AdModel';
import { AdDetailParams } from '../utils/params/AdDetailParam';
import { AdListModel } from '../model/AdListModel';
import { CacheConstants } from '../utils/constants/CacheConstants';
import { Duration } from 'core/src/main/ets/base/DurationModel';

export class AdDetailViewModel {
  private _state: AdDetailState = AdDetailState.initial();
  private listeners: Array<(state: AdDetailState) => void> = [];
  private readonly TAG = 'AdDetailViewModel';

  get state(): AdDetailState {
    return this._state;
  }

  set state(newState: AdDetailState) {
    this._state = newState;
    this.notifyListeners();
  }

  addListener(listener: (state: AdDetailState) => void): void {
    this.listeners.push(listener);
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener(this._state));
  }

  async init(): Promise<void> {

    const ble = await BleManager.getInstance()
    const notify = NotificationManager.getInstance()
    const storage = StorageManager.getInstance()

    ble.setOnBeaconFoundCallback(async (beaconData: IBeaconData) => {
      if (beaconData.uuid !== null && beaconData.major !== null && beaconData.minor !== null) {
        const ad: AdModel | undefined = AdDetailHelper.adList.find(ad => ad.beaconId === beaconData.uuid &&
          ad.major === beaconData.major && ad.minor === beaconData.minor);

        const data = await storage.getModelWithExpiry(CacheConstants.seenAds, AdListModel.fromJson)
        const historyData = await storage.getModelWithExpiry(CacheConstants.adHistory, AdListModel.fromJson)
        const item = data?.adList.find(item => item.beaconId === ad?.beaconId &&
          item.major === ad.major && item.minor === ad.minor)

        if (ad !== null && item === null) {
          LogManager.info(this.TAG, 'new ads detected')
          notify.publishSimpleNotification(ad!.title, ad!.description)
          const list = data?.adList ?? []
          const historyList = historyData?.adList ?? []
          list?.push(ad!)
          historyList.push(ad!)
          const newList = new AdListModel(list)
          const newHistoryList = new AdListModel(historyList)
          await storage.saveModelWithExpiry(CacheConstants.seenAds, newList, Duration.minutes(2))
          await storage.saveModelWithExpiry(CacheConstants.adHistory, newHistoryList, Duration.days(30))
        }
      }
    })


  }

  setParam(param: AdDetailParams) {
    this.state = this.state.with({adDetail: param})
  }
}
