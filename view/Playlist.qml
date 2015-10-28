import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../libs"

Page {
    property alias view: view
    property int lastIdx: -1
    property int currentId: -1
    property var currentItem: null
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
        query: "$.children[0].children[*]"
        source: main.requestUrl +"playlist.json"

        Component.onCompleted: {
            updateTimer.running = true;
        }

        function beforeUpdate() {
            updating = true;
            updateTimer.stop();
            lastIdx = view.selectedIndex;
        }

        // Bug - vlc sets 'current' for all playlist's items from same file uri
        // We cannot track the correct selected item from vlc in this case
        // So we'll always consider the first 'current' item
        function afterUpdate()
        {
            // Workaround - avoid problems caused by clear() from JSONListModel.updateModel()
            // When clear is called, view.selectedIndex changes automatically to 0
            view.selectedIndex = -1;

            for (var i = 0; i < count; i++)
            {
                currentItem = get(i);

                if (currentItem.current) {
                    currentId = currentItem.id;
                    view.selectedIndex = i;
                    break;
                }
            }

            // if stopped
            if (view.selectedIndex === -1) {
                view.selectedIndex = lastIdx;
                currentItem = null;
                currentId = -1;
            }
            updateTimer.restart();
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
            removable: true
            text: formatName(index, name)
            subText: formatTime(duration)
            onItemRemoved: {
                main.remove(view.model.get(index).id);
            }
        }

        onSelectedIndexChanged:
        {
            if (!updating && selectedIndex !== -1) {
                updateTimer.stop();
                currentItem = model.get(selectedIndex);
                currentId = currentItem.id;
                main.play(currentId);
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
