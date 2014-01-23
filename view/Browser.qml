import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../libs"

Page {
    property alias view: view
    property string dirPath: "/home"
    property string filePath: ""
    property string browseUrl: main.baseUrl +"browse.json"
    property bool updating: false

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Timer {
        id: updateTimer
        interval: 1000
        repeat: true
        onTriggered: model.request()
    }

    JSONListModel {
        id: model
        query: "$.element[*]"
        source: browseUrl +"?dir="+ dirPath

        Component.onCompleted: {
            updateTimer.running = true;
        }

        function beforeUpdate() {
            updating = true;
            view.selectedIndex = -1;
        }

        function afterUpdate() {
            updating = false;
        }
    }

    UList {
        id: view
        model: model
        expanded: true
        containerHeight: parent.height

        delegate: UDelegate {
            id: delegate
            text: formatName(name)
            constrainImage: true
            icon: resolveIcon(path, type);
        }

        onSelectedIndexChanged:
        {
            if (!updating)
            {
                updateTimer.stop();
                var currentItem = model.get(selectedIndex);

                if (currentItem.type === "dir") {
                    dirPath = currentItem.path;
                } else if (currentItem.type === "file") {
                    filePath = currentItem.path;
                    main.playInput(filePath);
                }
                updateTimer.restart();
            }
        }
    }


    function toogleExpanded() {
        view.expanded = !view.expanded;
    }

    function next() {
        select(view.selectedIndex+1);
    }

    function prev() {
        select(view.selectedIndex-1);
    }

    function select(idx)
    {
        if (idx < 0) {
            idx = model.count-1;
        }
        view.selectedIndex = idx % model.count;
    }

    function formatName(name)
    {
        if (name)
        {
            name = name.trim();
            var max = width / units.gu(1);

            if (name.length > max) {
                name = name.substr(0, max) +" ...";
            }
        }
        else {
            name = " ";
        }
        return name;
    }

    function formatTime(duration)
    {
        var date = new Date(duration*1000);
        date.setHours(date.getHours()-21);
        return Qt.formatTime(date, "hh:mm:ss");
    }

    function resolveIcon(path, type)
    {
        if (type === "dir") {
            return resolveFolder(path);
        } else {
            return "../img/text-x-generic.svg";
        }
    }

    // TODO - Internationalization support
    function resolveFolder(path)
    {
        var ext = "svg";
        var folder = "folder";

        if (path === "/home" || path === "/home/") {
            folder = "user-home";
        }
        else {
            path.match("/home.*/(..)");

            if (RegExp.$1 === "..") {
                folder = "go-up";
            }
            else {
                path.match("/home/.+/(.+)");
                var name = RegExp.$1;

                if (name === "..") {
                    folder = "go-up";
                }
                else if (name === "Desktop") {
                    folder = "user-desktop";
                }
                else if (name === "Documents") {
                    folder += "-documents";
                }
                else if (name === "Downloads") {
                    folder += "-download";
                }
                else if (name === "Music") {
                    folder += "-music";
                }
                else if (name === "Pictures") {
                    folder += "-pictures";
                }
                else if (name === "Videos") {
                    folder += "-video";
                }
                else if (name === "Public") {
                    folder += "-publicshare";
                }
                else if (name === "Template") {
                    folder += "-templates";
                }
                else if (name === "Ubuntu One") {
                    folder = "ubuntuone";
                    ext = "png"
                }
            }
        }
        return "../img/"+ folder +"."+ ext;
    }
}
