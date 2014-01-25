import QtQuick 2.0
import "../../view"

JSlider {
    jump: 10

    Component.onCompleted: {
        var imgPath = "../../img/";
        leftButton.source = imgPath +"backward.png";
        rightButton.source = imgPath +"forward.png";
    }

    function formatValue(v)
    {
        var minute = 60;
        var m = Math.floor(v/minute);
        var s = Math.floor(v%minute);

        if (m < 10) {
            m = "0"+ m;
        }
        if (s < 10) {
            s = "0"+ s;
        }
        return m +":"+ s;
    }

    function updateMaximumValue(duration)
    {
        if (duration) {
            maximumValue = duration
        } else {
            maximumValue = 100;
        }
    }

}
