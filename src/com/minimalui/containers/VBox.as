package com.minimalui.containers {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Style;
  import com.minimalui.base.Element;

  public class VBox extends BaseContainer {
    protected var mRealWidth:Number = 0;
    protected var mRealHeight:Number = 0;

    public function VBox(items:Vector.<Element> = null, idorcss:String = null, id:String = null) {
      super(idorcss, id);
      if(!items) return;
      for each(var i:Element in items) addChild(i);
      invalidateSize();
    }

    protected override function coreMeasure():void {
      var lastVerticalMargin:Number = Math.max(mStyle.getNumber("padding-top"), mStyle.getNumber("vertical-spacing"));
      var w:Number = mStyle.getNumber("padding-left") + mStyle.getNumber("padding-right");
      var h:Number= lastVerticalMargin;
      for each(var c:Element in mChildren) {
        c.measure();
        var cw:Number = c.measuredWidth;
        w = Math.max(w, cw + Math.max(mStyle.getNumber("padding-left"),  c.style.getNumber("margin-left") )
                           + Math.max(mStyle.getNumber("padding-right"), c.style.getNumber("margin-right"))
                     );

        var ch:Number = c.measuredHeight;
        h += ch;
        if(c.style.getNumber("margin-top") > lastVerticalMargin)
          h += (c.style.getNumber("margin-top") - lastVerticalMargin);
        h += (lastVerticalMargin = Math.max(c.style.getNumber("margin-bottom"), mStyle.getNumber("vertical-spacing")));
      }
      if(mStyle.getNumber("padding-bottom") > lastVerticalMargin)
        h += (mStyle.getNumber("padding-bottom") - lastVerticalMargin);
      mMeasuredWidth = Math.max(mRealWidth = w, mStyle.getNumber("width"));
      mMeasuredHeight = Math.max(mRealHeight = h, mStyle.getNumber("height"));
    }

    protected override function coreLayout():void {
      var c:Element;
      var contentH:Number = mRealHeight
        - Math.max(mStyle.getNumber("padding-top"), mStyle.getNumber("vertical-spacing"), mChildren[0].style.getNumber("margin-top"))
        - Math.max(mStyle.getNumber("padding-bottom"), mStyle.getNumber("vertical-spacing"), mChildren[mChildren.length-1].style.getNumber("margin-bottom"))
      var contentW:Number = mViewPort.width;

      var lastVerticalMargin:Number = 4000;
      var yy:Number = (mViewPort.height - contentH) / 2;
      switch(mStyle.getString("valign") || "middle") {
      case "top":
        yy = Math.max(mStyle.getNumber("padding-top"), mChildren[0].style.getNumber("margin-top"));
        break;
      case "bottom":
        yy = mViewPort.height - contentH;
        break;
      }

      for each(c in mChildren) {
        if(c.style.getNumber("margin-top") > lastVerticalMargin)
          yy += (c.style.getNumber("margin-top") - lastVerticalMargin);

        var xx:Number = 0;
        switch(mStyle.getString("align") || "center") {
        case "left":
          xx = Math.max(mStyle.getNumber("padding-left"), c.style.getNumber("margin-left"));
          break;
        case "center":
          xx = ((mViewPort.width - mStyle.getNumber("padding-left") - mStyle.getNumber("padding-right"))
                - c.measuredWidth) / 2 + mStyle.getNumber("padding-left");
          break;
        case "right":
          xx = mViewPort.width - c.measuredWidth
            - Math.max(mStyle.getNumber("padding-right"), c.style.getNumber("margin-right"));
          break;
        }

        c.layout(new Rectangle(xx, yy, c.measuredWidth, c.measuredHeight));

        lastVerticalMargin = Math.max(c.style.getNumber("margin-bottom"), mStyle.getNumber("vertical-spacing"));
        yy += c.measuredHeight + lastVerticalMargin;
      }
      setChanged();
    }
  }
}