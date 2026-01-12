import { PermissionManager, PermissionResult, PermissionType } from 'core/src/main/ets/permission/PermissionManager';
import { NotificationManager } from 'core/src/main/ets/notification/NotificationManager'
import { BackgroundManager } from 'core/src/main/ets/background/BackgroundManager'
import { MenuState } from '../state/MenuState';
import { common } from '@kit.AbilityKit';
import { LogManager } from 'core/src/main/ets/logger/LogManager';
import { NavigationConstants } from '../constants/NavigationConstants';
import { NavigationManager } from 'core/src/main/ets/navigation/NavigationManager';

export class MenuViewModel {
  private _state: MenuState = MenuState.initial();
  private listeners: Array<(state: MenuState) => void> = [];
  private readonly TAG = 'MenuViewModel';
  context? : common.UIAbilityContext;

  get state(): MenuState {
    return this._state;
  }

  set state(newState: MenuState) {
    this._state = newState;
    this.notifyListeners();
  }

  addListener(listener: (state: MenuState) => void): void {
    this.listeners.push(listener);
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener(this._state));
  }

  async init(context: common.UIAbilityContext): Promise<void> {
    this.state = this.state.with({ isLoading: true });
    this.context = context

    try {
      const bluetoothGranted = await this.requestBluetoothPermission(context);
      const notificationGranted = await this.requestNotificationPermission(context);
      LogManager.info(this.TAG, `bluetooth granted: ${bluetoothGranted} notification grandted: ${notificationGranted}`)

      if ((bluetoothGranted === PermissionResult.Granted) && (notificationGranted === true)) {
        NavigationManager.getInstance().pageInfos.pushPath({ name: NavigationConstants.dashboard });
      } else {
        this.state = this.state.with({ error: 'Bluetooth or notifications rejected.' });
      }
    } catch (e) {
      LogManager.error(this.TAG, `init() error: ${JSON.stringify(e)}`);
      this.state = this.state.with({ error: 'Permission error.' });
    } finally {
      this.state = this.state.with({ isLoading: false });
    }

    BackgroundManager.startBeaconBackgroundTask(this.context)
  }

  private async requestBluetoothPermission(context: common.UIAbilityContext): Promise<PermissionResult> {
    return await PermissionManager.getInstance().requestPermission(PermissionType.BLUETOOTH, context);
  }

  private async requestNotificationPermission(context: common.UIAbilityContext): Promise<boolean> {
    const nm = NotificationManager.getInstance()
    return await nm.requestPermission(context)
  }
}
