export interface ISettingsState {
  isLoading?: boolean;
  error?: string | null;
  message?: string;
  autoEnableBluetooth?: boolean;
  soundEnabled?: boolean;
}
