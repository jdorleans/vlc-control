import QtQuick 2.1
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../libs"

Page {

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Column {
        anchors.fill: parent
        spacing: units.gu(2)
        anchors.margins: units.gu(2)

        Row {
            height: tfHost.height
            width: parent.width
            spacing: units.gu(1)

            Label {
                id: lbHost
                text: i18n.tr("IP Address")
                fontSize: "large"
                anchors.verticalCenter: tfHost.verticalCenter
            }

            TextField {
                id: tfHost
                text: main.host
                height: units.gu(5)
                font.pixelSize: units.gu(2)
                color: focus ? "#EE6600" : "white"
                placeholderText: i18n.tr("IP Address (default: 192.168.000.001)")
                width: parent.width - lbHost.width - parent.spacing
//                inputMask: "009.009.009.009"
                onTextChanged: text = text.trim()
            }
        }

        Row {
            height: tfPort.height
            width: parent.width
            spacing: units.gu(1)

            Label {
                id: lbPort
                text: i18n.tr("Port")
                width: lbHost.width
                fontSize: "large"
                anchors.verticalCenter: tfPort.verticalCenter
            }

            TextField {
                id: tfPort
                text: main.port
                height: units.gu(5)
                font.pixelSize: units.gu(2)
                color: focus ? "#EE6600" : "white"
                placeholderText: i18n.tr("Port (default: 8080)")
                width: parent.width - lbPort.width - parent.spacing
//                inputMask: "00000"
                validator: IntValidator { bottom: 0; top: 99999; }
            }
        }

        Row {
            spacing: tfHost.width - btConfirm.width - btReset.width
            anchors.left: parent.left
            anchors.leftMargin: lbHost.width + units.gu(1)

            Button {
                id: btConfirm
                text: i18n.tr("Confirm")

                onClicked: {
                    if (validateIPAddress(tfHost.text)) {
                        main.host = tfHost.text;
                    }

                    if (isPositiveInt(tfPort.text)) {
                        main.port = tfPort.text;
                    }
                }
            }

            Button {
                id: btReset
                text: i18n.tr("Reset")
                gradient: UbuntuColors.greyGradient

                onClicked: {
                    main.host = tfHost.text = "192.168.0.1";
                    main.port = tfPort.text = "8080";
                }
            }
        }

    }

    function isPositiveInt(n) {
      return (!isNaN(parseInt(n)) && n > 0 && isFinite(n));
    }

    // Remember, this function will validate only Class C IP.
    // Change to other IP Classes as you need
    function validateIPAddress(ipaddr)
    {
        ipaddr = ipaddr.replace(/\s/g, "") //remove spaces for checking

        // Check for digits and in all 4 quadrants of the IP
        var re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;

        if (re.test(ipaddr))
        {
            var parts = ipaddr.split(".");

            if (!isPositiveInt(parts[0]) || !isPositiveInt(parts[3])) {
                return false;
            }

            //if any part is greater than 255
            for (var i=0; i<parts.length; i++) {
                if (parseInt(parseFloat(parts[i])) > 255){
                    return false;
                }
            }
            return true;
        }
        else {
            return false;
        }
    }
}
