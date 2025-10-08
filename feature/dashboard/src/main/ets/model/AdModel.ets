import { BaseModel } from 'core/src/main/ets/base/BaseModel';

export interface AdModelJson {
  beaconId: string
  major: number
  minor: number
  title: string
  description: string
  imageSrc: Resource
  code: string
}

export class AdModel implements BaseModel {
  beaconId: string
  major: number
  minor: number
  title: string
  description: string
  imageSrc: Resource
  code: string

  constructor(
    beaconId: string,
    major: number,
    minor: number,
    title: string,
    description: string,
    imageSrc: Resource,
    code: string
  ) {
    this.beaconId = beaconId;
    this.major = major;
    this.minor = minor;
    this.title = title;
    this.description = description;
    this.imageSrc = imageSrc;
    this.code = code;
  }

  toJson(): AdModelJson {
    return {
      beaconId: this.beaconId,
      major: this.major,
      minor: this.minor,
      title: this.title,
      description: this.description,
      imageSrc: this.imageSrc,
      code: this.code,
    };
  }

  static fromJson(json: AdModelJson): AdModel {
    return new AdModel(
      json.beaconId,
      json.major,
      json.minor,
      json.title,
      json.description,
      json.imageSrc,
      json.code
    );
  }
}