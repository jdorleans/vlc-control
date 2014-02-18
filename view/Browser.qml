import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../libs"

Page {
    property alias view: view
    property string dirPath: "/home"
    property string filePath: ""
    property string browseUrl: main.requestUrl +"browse.json"

    property var audioExts: ['mp3', 'flac', 'ogg', 'wav', 'mpa', 'm4a']
    property var videoExts: ['mkv', 'avi', 'mp4', 'mov', 'vob', 'wmv', 'ogv', 'f4v', 'mpg', 'flv', 'asf', 'm4v', 'swf', 'swt']

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
            view.selectedIndex = -1;
        }

        // VLC BUG - app crashes when accessing some folders such as: /etc or /sbin
        function afterUpdate()
        {
            var re = /^\/.*\/.*\/\.\.$/

            if (!re.test(dirPath))
            {
                re = /^\/.*\/\.\.$/

                if (re.test(dirPath)) {
                    remove(0);
                }
            }
        }
    }

    Column {
        spacing: units.gu(1)
        anchors.fill: parent
        anchors.topMargin: units.gu(1)

        Label {
            id: lbPath
            text: fixPath()
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: units.gu(1)
            anchors.rightMargin: units.gu(1)

            function fixPath()
            {
                var path = dirPath;
                var re = /^\/.*\/.*\/\.\.$/

                if (re.test(dirPath)) {
                    dirPath.match("(\/.*)\/.*\/\.\.");
                    path = RegExp.$1;
                }
                else {
                    re = /^\/.*\/\.\.$/

                    if (re.test(dirPath)) {
                        path = "/"
                    }
                }
                return path;
            }
        }

        UList {
            id: view
            model: model
            expanded: true
            containerHeight: parent.height - lbPath.height - units.gu(1)

            delegate: UDelegate {
                id: delegate
                text: formatName(name)
                constrainImage: true
                icon: resolveIcon(path, type);

                Component.onCompleted: {
                    leftImage.height -= units.gu(1);
                }
            }

            onSelectedIndexChanged:
            {
                if (selectedIndex !== -1)
                {
                    updateTimer.stop();
                    var item = model.get(selectedIndex);

                    if (item.type === "dir") {
                        dirPath = item.path;
                    } else if (item.type === "file") {
                        filePath = item.path;
                        main.playInput(filePath);
                    }
                    selectedIndex = -1;
                    updateTimer.restart();
                }
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
            return resolveFile(path);
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
            path.match("/.*(\.\.)");

            if (RegExp.$1 === "..") {
                folder = "go-up";
            }
            else {
                path.match("/home/.+/(.+)");
                var name = RegExp.$1;

                if (name === "Desktop") {
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
                else if (name === "Dropbox") {
                    folder = "dropbox";
                    ext = "png"
                }
            }
        }
        return "../img/"+ folder +"."+ ext;
    }

    function resolveFile(path)
    {
        var ext = "svg";
        var file = "text";
        var suffix = "-x-generic";
        var extPath = path.slice(-3);

        if (isAudioExt(extPath)) {
            file = "audio";
        } else if (isVideoExt(extPath)) {
            file = "video";
        }
        return "../img/"+ file + suffix +"."+ ext;
    }

    function isAudioExt(ext) {
        return find(ext, audioExts);
    }

    function isVideoExt(ext) {
        return find(ext, videoExts);
    }

    function find(ext, exts)
    {
        for (var e in exts) {
            if (ext === exts[e]) {
                return true;
            }
        }
        return false;
    }
}
