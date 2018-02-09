class RobotAppearance {
  private color _backColor = 32;// #FFE308;
  private color _shoulderColor =  #FF5733; //#E4694F  ;
  private color _armcolor = #FFF200; //#FFEB00;
  RobotAppearance() {
  }
  RobotAppearance(color backColor, color shoulderColor, color armcolor) {
    this._backColor = backColor;
    this._shoulderColor = shoulderColor  ;
    this._armcolor = armcolor;
  }

  public color getBackColor() {
    return this._backColor ;
  }
  public color getShoulderColor() {
    return this._shoulderColor ;
  }
  public color getArmColor() {
    return this._armcolor ;
  }
}