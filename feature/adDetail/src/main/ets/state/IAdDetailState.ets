import { AdDetailParams } from '../utils/params/AdDetailParam';

export interface IAdDetailState {
  isLoading?: boolean;
  error?: string | null;
  message?: string;
  adDetail?: AdDetailParams | null;
}
