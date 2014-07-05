import QtQuick 2.1
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../libs"

Page {

    // Backgro1und
    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Column {
        anchors.fill: parent
        spacing: units.gu(2)
        anchors.margins: units.gu(2)

        Label {
            id: lbHost
            text: i18n.tr("IP Address")
            fontSize: "large"
        }

        TextField {
            id: tfHost
            text: main.host
            height: units.gu(5)
            font.pixelSize: units.gu(2)
            color: focus ? "#EE6600" : "white"
            placeholderText: i18n.tr("default: 192.168.0.1")
//          inputMask: "009.009.009.009"
            anchors.left: parent.left
            anchors.right: parent.right
            onTextChanged: text = text.trim()
        }

        Label {
            id: lbPort
            text: i18n.tr("Port")
            fontSize: "large"
        }

        TextField {
            id: tfPort
            text: main.port
            height: units.gu(5)
            font.pixelSize: units.gu(2)
            color: focus ? "#EE6600" : "white"
            placeholderText: i18n.tr("default: 8080")
//          inputMask: "00000"
            anchors.left: parent.left
            anchors.right: parent.right
            validator: IntValidator { bottom: 0; top: 99999; }
        }

        Label {
            id: lbPass
            text: i18n.tr("Password")
            fontSize: "large"
        }

        TextField {
            id: tfPass
            text: main.password
            height: units.gu(5)
            font.pixelSize: units.gu(2)
            color: focus ? "#EE6600" : "white"
            placeholderText: i18n.tr("default: none")
//          inputMask: "00000"
            anchors.left: parent.left
            anchors.right: parent.right
            onTextChanged: text = text.trim()
        }

        Row {
            spacing: tfHost.width - btConfirm.width - btReset.width
            anchors.left: parent.left

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
                    main.password = tfPass.text;
                }
            }

            Button {
                id: btReset
                text: i18n.tr("Reset")
                gradient: UbuntuColors.greyGradient

                onClicked: {
                    main.host = tfHost.text = "192.168.0.1";
                    main.port = tfPort.text = "8080";
                    main.password = tfPass.text = "";
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

    function connect(host, port) {
        tfHost.text = host;
        tfPort.text = port;
    }
}
