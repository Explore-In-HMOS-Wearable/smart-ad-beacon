import { PermissionManager, PermissionResult, PermissionType } from 'core/src/main/ets/permission/PermissionManager';
import { NotificationManager } from 'core/src/main/ets/notification/NotificationManager'
import { BackgroundManager } from 'core/src/main/ets/background/BackgroundManager'
import { SplashState } from '../state/SplashState';
import { common } from '@kit.AbilityKit';
import { LogManager } from 'core/src/main/ets/logger/LogManager';
import { NavigationConstants } from '../constants/NavigationConstants';
import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager';

export class SplashViewModel {
  private _state: SplashState = SplashState.initial();
  private listeners: Array<(state: SplashState) => void> = [];
  private readonly TAG = 'SplashViewModel';
  context = getContext(this) as common.UIAbilityContext;

  get state(): SplashState {
    return this._state;
  }

  set state(newState: SplashState) {
    this._state = newState;
    this.notifyListeners();
  }

  addListener(listener: (state: SplashState) => void): void {
    this.listeners.push(listener);
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener(this._state));
  }

  async init(): Promise<void> {
    this.state = this.state.with({ isLoading: true });

    try {
      const bluetoothGranted = await this.requestBluetoothPermission();
      const notificationGranted = await this.requestNotificationPermission();
      LogManager.info(this.TAG,`bluetooth granted: ${bluetoothGranted} notification grandted: ${notificationGranted}`)

      if ((bluetoothGranted === PermissionResult.Granted) && (notificationGranted === true)) {
        LogManager.info(this.TAG, 'Tüm izinler alındı');
        NavigationManager.getInstance().pageInfos.replacePath({ name: NavigationConstants.dashboard });
      } else {
        LogManager.warn(this.TAG, 'Gerekli izinlerden biri eksik');
        this.state = this.state.with({ error: 'Bluetooth veya bildirim izni reddedildi.' });
      }
    } catch (e) {
      LogManager.error(this.TAG, `init() error: ${JSON.stringify(e)}`);
      this.state = this.state.with({ error: 'İzinler alınırken hata oluştu.' });
    } finally {
      this.state = this.state.with({ isLoading: false });
    }

  }

  private async requestBluetoothPermission(): Promise<PermissionResult> {
    const context = getContext(this) as common.UIAbilityContext;
    return await PermissionManager.getInstance().requestPermission(PermissionType.BLUETOOTH, context);
  }

  private async requestNotificationPermission(): Promise<boolean> {
    const nm = NotificationManager.getInstance()
    const context = getContext(this) as common.UIAbilityContext;
    return await nm.requestPermission(context)
  }
}
