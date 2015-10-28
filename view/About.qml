import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../libs"

Page {

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Column {
        spacing: units.gu(4)
        anchors.top: parent.top
        anchors.topMargin: units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            width: 128
            fillMode: Image.PreserveAspectFit
            source: "../img/icon.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            spacing: units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                fontSize: "large"
                text: i18n.tr("Created by")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                spacing: units.gu(1)
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    fontSize: "large"
                    text: i18n.tr("Jonathan D'Orleans")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    color: "#EE6600"
                    text: i18n.tr("<jonathan.dorleans@gmail.com>")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

            }

        }

    }

}
