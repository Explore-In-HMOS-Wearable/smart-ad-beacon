import { AdDetailParams } from '../utils/params/AdDetailParam';
import { IAdDetailState } from './IAdDetailState';

export class AdDetailState {
  public isLoading: boolean;
  public readonly error?: string;
  public message?: string;
  public adDetail?: AdDetailParams;

  constructor(init: IAdDetailState) {
    this.isLoading = init.isLoading ?? true;
    this.error = init.error === null ? undefined : init.error;
    this.message = init.message === null ? undefined : init.message;
    this.adDetail = init.adDetail === null ? undefined : init.adDetail;
  }

  with(updates: IAdDetailState): AdDetailState {
    return new AdDetailState({
      isLoading: updates.isLoading ?? this.isLoading,
      error: updates.error === null ? undefined : (updates.error ?? this.error),
      message: updates.message === null ? undefined : (updates.message ?? this.message),
      adDetail: updates.adDetail === null ? undefined : (updates.adDetail ?? this.adDetail)
    });
  }

  static initial(): AdDetailState {
    return new AdDetailState({
      isLoading: false,
      error: null,
      message: '',
      adDetail: null,
    });
  }
}