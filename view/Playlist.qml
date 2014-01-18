import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../libs"

Page {
    property alias view: view
    property var currentItem: null
    property bool updateState: false

    // TODO - TEST ONLY
//    tools: ToolbarItems {
//        locked: true
//        opened: true
//        ToolbarButton {
//            text: i18n.tr("Playlist")
//            iconSource: "../img/repeat2.png"
//            onTriggered: toogleExpanded()
//        }
//        ToolbarButton {
//            text: i18n.tr("Shuffle")
//            iconSource: "../img/shuffle.png"
//            onTriggered: print("shuffle")
//        }
//    }

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
        query: "$.children[0].children[*]"
        source: main.baseUrl +"playlist.json"
        property bool ready: false

        Component.onCompleted: {
            ready = true;
            updateTimer.running = true;
        }

        function beforeUpdate()
        {
            if (ready) {
                updateState = true;
                currentItem = null;
                view.selectedIndex = -1;
            }
        }

        function afterUpdate()
        {
            if (!ready) {
                return;
            }

            for (var i = 0; i < count; i++)
            {
                var item = get(i);

                if (item.current)
                {
                    currentItem = item;
                    view.selectedIndex = i;
                    updateTimer.restart();
                    break;
                }
            }
            updateState = false;
        }
    }

    UList {
        id: view
        model: model
        expanded: true
        containerHeight: parent.height

        delegate: OptionSelectorDelegate {
            id: delegate
            text: formatName(index, name)
            subText: formatTime(duration)
        }

        onSelectedIndexChanged:
        {
            if (!updateState) {
                updateTimer.stop();
                currentItem = model.get(selectedIndex);
                main.play(currentItem.id);
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

    function formatName(index, name)
    {
        if (name)
        {
            name = name.trim();
            var max = width / units.gu(1);

            if (name.length > max) {
                name = name.substr(0, max) +" ...";
            }
        }
        return (index+1) +". "+ name;
    }

    function formatTime(duration)
    {
        var date = new Date(duration*1000);
        date.setHours(date.getHours()-21);
        return Qt.formatTime(date, "hh:mm:ss");
    }

}
