import QtQuick 2.4
import Ubuntu.Components 1.2

Item {
    height: units.gu(5)
    property real jump: 5
    property alias value: mainSlider.value
    property alias minimumValue: mainSlider.minimumValue
    property alias maximumValue: mainSlider.maximumValue
    property alias leftButton: btLeft
    property alias rightButton: btRight
    property alias slider: mainSlider

    anchors.leftMargin: units.gu(1)
    anchors.rightMargin: anchors.leftMargin

    JButton {
        id: btLeft
        anchors.left: parent.left
        anchors.verticalCenter: mainSlider.verticalCenter

        onClick: backward();
    }

//    Label {
//        text: formatValue(value)
//        fontSize: "large"
//        anchors.verticalCenter: mainSlider.verticalCenter
//        avnchors.horizontalCenter: mainSlider.horizontalCenter
//    }
    Slider {
        id: mainSlider
        live: true
        anchors.left: btLeft.right
        anchors.right: btRight.left
        anchors.leftMargin: units.gu(1)
        anchors.rightMargin: anchors.leftMargin
        anchors.verticalCenter: parent.verticalCenter

        function formatValue(v) { return parent.formatValue(v) }
    }

    JButton {
        id: btRight
        anchors.right: parent.right
        anchors.verticalCenter: mainSlider.verticalCenter

        onClick: forward();
    }


    function formatValue(v) {
        return v;
    }

    function isPressed() {
        return (mainSlider.pressed || btLeft.pressed || btRight.pressed)
    }

    function updateValue(val)
    {
        if (!isPressed()) {
            value = val;
        }
    }

    function backward(amount)
    {
        var val = value;

        if (amount) {
            val -= amount;
        } else {
            val -= jump;
        }

        if (val < minimumValue) {
            val = minimumValue;
        }
        value = val;
    }

    function forward(amount)
    {
        var val = value;

        if (amount) {
            val += amount;
        } else {
            val += jump;
        }

        if (val > maximumValue) {
            val = maximumValue;
        }
        value = val;
    }

}
