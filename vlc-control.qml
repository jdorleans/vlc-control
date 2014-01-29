import QtQuick 2.0
import Ubuntu.Components 0.1
import "view"
import "view/control"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.jdorleans.vlc-control"

    id: main
    width: units.gu(55)
    height: units.gu(90)
    backgroundColor: "#333"
//    automaticOrientation: true

    property string protocol: "http"
    property string host: "localhost"
//    property string host: "192.168.000.001" // default ip
    property int port: 8080
    property string baseUrl: ""
    property string statusUrl: ""
    property var currentState: null

    property string cmdPlay: "pl_play"
    property string cmdPause: "pl_pause"
    property string cmdStop: "pl_stop"
    property string cmdNext: "pl_next"
    property string cmdPrev: "pl_previous"
    property string cmdDelete: "pl_delete&id="
    property string cmdEmpty: "pl_empty"
    property string cmdSeek: "seek&val="
    property string cmdVolume: "volume&val="
    property string cmdPlayInput: "in_play&input="

    Component.onCompleted: {
        createBaseUrl();
        updateTimer.running = true;
    }

    onHostChanged: createBaseUrl();
    onPortChanged: createBaseUrl();

    Timer {
        id: updateTimer
        interval: 1000
        repeat: true
        onTriggered: updateStatus()
    }

//    NetworkFinder { id: networkFinder }


    Tabs {

        Tab {
            title: i18n.tr("Control")
            anchors.fill: parent
            page: Control { id: control }
        }

        Tab {
            title: i18n.tr("Playlist")
            anchors.fill: parent
            page: Playlist { id: playlist }
        }

        Tab {
            title: i18n.tr("Browser")
            anchors.fill: parent
            page: Browser { id: browser }
        }

        Tab {
            title: i18n.tr("Connection")
            anchors.fill: parent
            page: Connection { id: connection }
        }

    }


    function createBaseUrl() {
        baseUrl = protocol +"://"+ host +":"+ port +"/requests/";
        createStatusUrl();
        return baseUrl;
    }

    function createStatusUrl() {
        statusUrl = baseUrl +"status.json";
        updateStatus();
        return statusUrl;
    }

    function request(url)
    {
//        console.log("Main - Request: "+ url);
        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                currentState = JSON.parse(xhr.responseText);
            }
        }
        xhr.open("GET", url);
        xhr.send();
    }

    function execute(command) {
        updateTimer.stop();
        request(statusUrl +"?command="+ command);
        updateTimer.restart();
    }

    function updateStatus() {
        request(statusUrl);
    }

    function play(id)
    {
        if (id) {
            execute(cmdPlay +"&id="+ id);
        } else {
            execute(cmdPlay);
        }
    }
    function pause() {
        execute(cmdPause);
    }
    function stop() {
        execute(cmdStop);
    }

    function next() {
        execute(cmdNext);
    }
    function previous() {
        execute(cmdPrev);
    }

    function remove(id) {
        execute(cmdDelete+id);
    }
    function empty() {
        execute(cmdEmpty);
    }

    function seek(val) {
        execute(cmdSeek+val);
    }

    function volume(val) {
        execute(cmdVolume+val);
    }

    function playInput(url) {
        execute(cmdPlayInput + url);
    }
}
