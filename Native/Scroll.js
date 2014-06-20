Elm.Native.Scroll = {};
Elm.Native.Scroll.make = function(elm) {

    elm.Native = elm.Native || {};
    elm.Native.Scroll = elm.Native.Scroll || {};
    if (elm.Native.Scroll.values) return elm.Native.Scroll.values;

    var Signal = Elm.Signal.make(elm);
    var Utils  = Elm.Native.Utils.make(elm);

    var deltaY = Signal.constant(0);
    deltaY.defaultNumberOfKids = 1;

    // var scrollY = A2(Signal.lift, function(p){console.log(p);return p}, deltaY);
    // scrollY.defaultNumberOfKids = 0;

    var node = elm.display === ElmRuntime.Display.FULLSCREEN ? document : elm.node;

    elm.addListener([deltaY.id], node, 'wheel', function wheel(e) {
        // console.log("notifying:");
        // console.log(e);
        elm.notify(deltaY.id, e.wheelDeltaY);
    });

    return elm.Native.Scroll.values = {
        deltaY: deltaY
    };
};