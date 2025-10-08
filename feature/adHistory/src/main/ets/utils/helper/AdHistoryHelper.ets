import { AdModel } from '../../model/AdModel'

export class AdHistoryHelper {
  static adList: AdModel[] = [
    new AdModel(
      '58304cb1-1df0-43f9-b9ee-4cd4271f8070',
      0,
      1,
      'Huawei Watch5',
      '20% Sale only 2 hours!',
      $r('app.media.ad1'),
      '414748-ad11133'
    ),
    new AdModel(
      '58304cb1-1df0-43f9-b9ee-4cd4271f8070',
      0,
      2,
      'Demon Jeans',
      'Get 2 pay 1 for jeans in Demon Jeans.',
      $r('app.media.ad2'),
      '414748-ad11133'
    ),
    new AdModel(
      '58304cb1-1df0-43f9-b9ee-4cd4271f8070',
      0,
      3,
      'Aj Jeans',
      'New season products',
      $r('app.media.ad3'),
      '414748-ad11133'
    ),
    new AdModel(
      '58304cb1-1df0-43f9-b9ee-4cd4271f8070',
      0,
      4,
      'Mavi Denim',
      'Buy 1 second is 50% Sale',
      $r('app.media.ad4'),
      '414748-ad11133'
    ),
  ]
}
