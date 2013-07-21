package com.minimalui.base {
  import flash.events.MouseEvent;

  import com.minimalui.base.Element;
  import com.minimalui.base.BaseButton;
  import com.minimalui.containers.RawLayout;
  import com.minimalui.base.layout.ILayout;
  import com.minimalui.decorators.Background;
  import com.minimalui.decorators.Border;

  public class CheckboxBase extends BaseButton {
    public final function get checked():Boolean {
      return style.hasValue("checked") ? getStyle("checked") == "yes" : false;
    }

    public final function set checked(bb:Boolean):void {
      setStyle("checked", bb ? "yes" : "no");
    }

    public function CheckboxBase(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }

    protected override function onMouseClick():void {
      checked = !checked;
    }
  }
}