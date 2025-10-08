import './ISettingsState'
import { ISettingsState } from './ISettingsState';

export class SettingsState {
  public isLoading: boolean;
  public readonly error?: string;
  public message?: string;
  public autoEnableBluetooth?: boolean;
  public soundEnabled?: boolean;


  constructor(init: ISettingsState) {
    this.isLoading = init.isLoading ?? true;
    this.error = init.error === null ? undefined : init.error;
    this.message = init.message === null ? undefined : init.message;
    this.autoEnableBluetooth = init.autoEnableBluetooth ?? false;
    this.soundEnabled = init.soundEnabled ?? false;
  }

  with(updates: ISettingsState): SettingsState {
    return new SettingsState({
      isLoading: updates.isLoading ?? this.isLoading,
      error: updates.error === null ? undefined : (updates.error ?? this.error),
      message: updates.message === null ? undefined : (updates.message ?? this.message),
      autoEnableBluetooth: updates.autoEnableBluetooth ?? this.autoEnableBluetooth,
      soundEnabled: updates.soundEnabled ?? this.soundEnabled,
    });
  }

  static initial(): SettingsState {
    return new SettingsState({
      isLoading: false,
      error: null,
      message: '',
      autoEnableBluetooth: false,
      soundEnabled: false,
    });
  }
}
