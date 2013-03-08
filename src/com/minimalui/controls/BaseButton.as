package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  // import flash.geom.Point;

  import com.minimalui.events.MEvent;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.containers.HBox;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;
  import com.minimalui.tools.Tools;

  /**
   * Implements basic Button.
   */
  public class BaseButton extends HBox {
    public static const TEXT:String = "text";
    public static const BACKGROUND_COLOR:String = "background-color";
    public static const DISABLED:String = "disabled";

    private var mLabel:Label;
    private var mCallback:Function;

    private var mIsMouseDown:Boolean = false;
    private var mIsMouseOver:Boolean = false;

    /**
     * Easy shortcut to click event. Dispatched before calling firing click event.
     *
     * @param f callback called on clicking.
     */
    public final function set onClick(f:Function):void {
      mCallback = f;
    }

    /**
     * If mouse is currently down.
     */
    protected function get isMouseDown():Boolean { return mIsMouseDown; }

    /**
     * If mouse is currently over.
     */
    protected function get isMouseOver():Boolean { return mIsMouseOver; }

    /**
     * Default constructor.
     *
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
   public function BaseButton(idorcss:String = null, id:String = null) {
      super(null, idorcss, id);
      useHandCursor = buttonMode = true;
      construct();
      addMouseListeners();
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([DISABLED]))) {
        useHandCursor = buttonMode = getStyle(DISABLED) == "true";
        setChanged();
      }
      if(hasChanged(Vector.<String>([TEXT]))) {
        mLabel.setStyle(Label.TEXT_CONTENT, getStyle(TEXT));
      }
      super.coreCommitProperties();
    }

    private function coreOnClick(me:MouseEvent):void {
      if(mCallback !== null) mCallback();
      dispatchEvent(new MEvent(MEvent.BUTTON_CLICK));
      layoutManager.forceUpdate();
    }

    private function addMouseListeners():void {
      addEventListener(MouseEvent.CLICK, coreOnClick);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function onMouseMove(me:MouseEvent):void {
      setChanged();
    }

    private function onMouseOver(me:MouseEvent):void {
      addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      mIsMouseOver = true;
      setChanged();
    }

    private function onMouseOut(me:MouseEvent):void {
      removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      mIsMouseOver = false;
      setChanged();
    }

    private function onMouseDown(me:MouseEvent):void {
      mIsMouseDown = true;
      setChanged();
      layoutManager.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function onMouseUp(me:MouseEvent):void {
      mIsMouseDown = false;
      setChanged();
    }

    private function construct():void {
      mLabel = new Label(getStyle("text") as String);
      addChild(mLabel);
    }
  }
}
