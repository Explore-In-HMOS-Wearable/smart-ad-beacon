import { AdModel } from '../model/AdModel';
import './IDashboardState'
import { IDashboardState } from './IDashboardState';

export class DashboardState {
  public isLoading: boolean;
  public readonly error?: string;
  public message?: string;
  public isScanning?: boolean;
  public distance?: number;
  public readonly latestAd?: AdModel;

  constructor(init: IDashboardState) {
    this.isLoading = init.isLoading ?? true;
    this.error = init.error === null ? undefined : init.error;
    this.message = init.message === null ? undefined : init.message;
    this.isScanning = init.isScanning ?? false;
    this.distance = init.distance;
    this.latestAd = init.latestAd === null ? undefined : init.latestAd;
  }

  with(updates: IDashboardState): DashboardState {
    return new DashboardState({
      isLoading: updates.isLoading ?? this.isLoading,
      error: updates.error === null ? undefined : (updates.error ?? this.error),
      message: updates.message === null ? undefined : (updates.message ?? this.message),
      isScanning: updates.isScanning ?? this.isScanning,
      distance: updates.distance ?? this.distance,
      latestAd: updates.latestAd === null ? undefined : (updates.latestAd ?? this.latestAd)
    });
  }

  static initial(): DashboardState {
    return new DashboardState({
      isLoading: false,
      error: null,
      message: '',
      isScanning: false,
      distance: 0,
      latestAd: null,
    });
  }
}
