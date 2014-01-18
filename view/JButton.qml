import QtQuick 2.0

Image {
    width: size
    height: size
    property int size: 48
    property alias pressed: actionArea.pressed
    property alias mouseArea: actionArea
    property alias timer: updater

    signal click

    MouseArea {
        id: actionArea
        anchors.fill: parent
        onClicked: click()
    }
    Timer {
        id: updater
        interval: 100
        running: actionArea.pressed
        repeat: true
        onTriggered: click()
    }

}
