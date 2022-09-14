const MAIN_TAG = 'Log'
//日志

export class logger {
  tag =MAIN_TAG

  constructor(tag) {
    this.tag += tag + ' '
  }
  log(msg:string) {
    console.log(this.tag + msg)
  }
  info(msg) {
    console.info(this.tag + msg)
  }
  error(msg) {
    console.error(this.tag + msg)
  }
}