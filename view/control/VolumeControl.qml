import QtQuick 2.4
import "../../view"

JSlider {
    maximumValue: 125 // percent
    property real vlcMaxVol: (vlcVolume*maximumValue)
    property real vlcVolume: 2.56
    property real percent: 0.390625

    Component.onCompleted: {
        var imgPath = "../../img/";
        leftButton.source = imgPath +"vol-0.png";
        rightButton.source = imgPath +"vol-4.png";
    }

    function formatValue(v) {
        return round(v) +"%";
    }

    function updateVolume(val) {
        updateValue(convertToApp(val));
    }

    function convertToVLC(val) {
        return Math.ceil(round(val)*vlcVolume);
    }

    function convertToApp(val) {
        return Math.floor(val*percent);
    }

    function round(val) {
        return Math.round(val);
    }
}
