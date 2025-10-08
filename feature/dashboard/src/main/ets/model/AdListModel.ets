import { BaseModel } from 'core/src/main/ets/base/BaseModel';
import { AdModel, AdModelJson } from './AdModel';

export interface AdListModelJson {
  adList: AdModelJson[];
}

export class AdListModel implements BaseModel {
  adList: AdModel[];

  constructor(adList: AdModel[]) {
    this.adList = adList;
  }

  toJson(): AdListModelJson {
    return {
      adList: this.adList.map(adList => adList.toJson())
    };
  }

  static fromJson(json: AdListModelJson): AdListModel {
    const adList = json.adList.map(adList => AdModel.fromJson(adList));
    return new AdListModel(adList);
  }
}