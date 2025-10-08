export class AdModel {
  uuid: string;
  major: number;
  minor: number;
  title: string;
  message: string;
  imageSrc?: Resource;

  constructor(
    uuid: string,
    major: number,
    minor: number,
    title: string,
    message: string,
    imageSrc?: Resource
  ) {
    this.uuid = uuid;
    this.major = major;
    this.minor = minor;
    this.title = title;
    this.message = message;
    this.imageSrc = imageSrc;
  }
}
