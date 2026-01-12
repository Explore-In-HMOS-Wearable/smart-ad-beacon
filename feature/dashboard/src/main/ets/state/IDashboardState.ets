import { AdModel } from '../model/AdModel';

export interface IDashboardState {
  isLoading?: boolean;
  error?: string | null;
  message?: string;
  isScanning?: boolean;
  distance?: number;
  latestAd?: AdModel | null;
}
