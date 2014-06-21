Elm.Native.Scroll = {};
Elm.Native.Scroll.make = function(elm) {

    elm.Native = elm.Native || {};
    elm.Native.Scroll = elm.Native.Scroll || {};
    if (elm.Native.Scroll.values) return elm.Native.Scroll.values;

    var Signal = Elm.Signal.make(elm);
    var Utils  = Elm.Native.Utils.make(elm);

    /*
     | Thanks http://phrogz.net/JS/wheeldelta.html
    */
    var wheelDistance = function(evt){
        if (!evt) evt = event;
        var w=evt.wheelDelta, d=evt.detail, r=0.0;
        if (d){
            if (w) r = w/d/40*d>0?1:-1; // Opera
            else r = -d/3;              // Firefox;         TODO: do not /3 for OS X
        } else r = w/120;             // IE/Safari/Chrome TODO: /3 for Chrome OS X
        
        // prevent other wheel events and bubbling in general
        if(evt.stopPropagation) evt.stopPropagation();
        evt.cancelBubble = true;
        // most often you want to prevent default scrolling behavior (full page scroll!)
        if(evt.preventDefault) evt.preventDefault();
        evt.returnValue = false;
        elm.notify(delta.id, r);
    };

    var delta = Signal.constant(0);
    // delta.defaultNumberOfKids = 2;


    // var deltaX = A2(Signal.lift, function(p){return p._0}, delta);
    // deltaX.defaultNumberOfKids = 0;
    // var deltaY = A2(Signal.lift, function(p){return p._1}, delta);
    // deltaY.defaultNumberOfKids = 0;

    var node = elm.display === ElmRuntime.Display.FULLSCREEN ? document : elm.node;

    // elm.addListener([delta.id], node, 'wheel', wheelDistance);
    elm.addListener([delta.id], node, 'DOMMouseScroll', wheelDistance);
    elm.addListener([delta.id], node, 'mousewheel', wheelDistance);

    return elm.Native.Scroll.values =
        { delta : delta
        // , dy    : deltaY
        // , dx    : deltaX
        };
};