import { AdModel } from '../model/AdModel';
import {IAdHistoryState } from './IAdHistoryState';


export class AdHistoryState {
  public isLoading: boolean;
  public readonly error?: string;
  public message?: string;
  public ads?: AdModel[];


  constructor(init: IAdHistoryState) {
    this.isLoading = init.isLoading ?? true;
    this.error = init.error === null ? undefined : init.error;
    this.message = init.message === null ? undefined : init.message;
    this.ads = init.ads ?? []
  }

  with(updates: IAdHistoryState): AdHistoryState {
    return new AdHistoryState({
      isLoading: updates.isLoading ?? this.isLoading,
      error: updates.error === null ? undefined : (updates.error ?? this.error),
      message: updates.message === null ? undefined : (updates.message ?? this.message),
      ads: updates.ads ?? this.ads,
    });
  }

  static initial(): AdHistoryState {
    return new AdHistoryState({
      isLoading: false,
      error: null,
      message: '',
      ads: []
    });
  }
}
