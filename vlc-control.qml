import QtQuick 2.4
import Ubuntu.Components 1.2
import U1db 1.0 as U1db
import "view"
import "view/control"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "com.ubuntu.developer.jdorleans.vlc-control"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.jdorleans.vlc-control"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    //useDeprecatedToolbar: false

    id: main
    width: units.gu(46)
    height: units.gu(78)
    backgroundColor: "#333"

    property string protocol: "http"
    property string host: "192.168.0.1" // default ip
    property int port: 8080
    property string password: ""
    property string baseUrl: ""
    property string requestUrl: ""
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
        loadConnectionData();
        createBaseUrl();
        updateTimer.running = true;
        connection.connect(host, port);
    }

    onHostChanged: createBaseUrl();
    onPortChanged: createBaseUrl();

    U1db.Database {
        id: db;
        path: "vlc-control.u1db"
    }

    U1db.Document {
        id: dbConnection
        database: db
        docId: "connection"
        create: true
    }

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

        Tab {
            title: i18n.tr("About")
            anchors.fill: parent
            page: About { id: about }
        }

    }

    function loadConnectionData()
    {
        if (dbConnection.contents)
        {
            if (dbConnection.contents.host) {
                host = dbConnection.contents.host;
            }
            if (dbConnection.contents.port) {
                port = dbConnection.contents.port;
            }
            if (dbConnection.contents.password) {
                password = dbConnection.contents.password;
            }
        }
    }

    function createBaseUrl() {
        baseUrl = protocol +"://"+ host +":"+ port +"/";
        createRequestUrl();
        return baseUrl;
    }

    function createRequestUrl() {
        requestUrl = baseUrl +"requests/";
        createStatusUrl();
        return requestUrl;
    }

    function createStatusUrl() {
        statusUrl = requestUrl +"status.json";
        updateStatus();
        return statusUrl;
    }

    function request(url)
    {
        //console.log("Main - Request: "+ url);
        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                currentState = JSON.parse(xhr.responseText);
            }
        }
        xhr.open("GET", url, true, '', password);
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

