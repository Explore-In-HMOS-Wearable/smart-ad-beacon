import { AdModel } from "../model/AdModel";

export interface IAdHistoryState {
  isLoading?: boolean;
  error?: string | null;
  message?: string;
  ads?: AdModel[];
}
