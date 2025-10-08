import './IMenuState'
import { IMenuState } from './IMenuState';

export class MenuState {
  public isLoading: boolean;
  public readonly error?: string;
  public message?: string;

  constructor(init: IMenuState) {
    this.isLoading = init.isLoading ?? true;
    this.error = init.error === null ? undefined : init.error;
    this.message = init.message === null ? undefined : init.message;
  }

  with(updates: IMenuState): MenuState {
    return new MenuState({
      isLoading: updates.isLoading ?? this.isLoading,
      error: updates.error === null ? undefined : (updates.error ?? this.error),
      message: updates.message === null ? undefined : (updates.message ?? this.message),
    });
  }

  static initial(): MenuState {
    return new MenuState({
      isLoading: false,
      error: null,
      message: '',
    });
  }
}
