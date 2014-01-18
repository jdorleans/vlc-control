import QtQuick 2.0
import Ubuntu.Components 0.1

Rectangle {
    color: "#DD000000"
    height: column.height + units.gu(2)

    property var meta

    onMetaChanged: {        
        updateTitle(meta);
        updateAlbum(meta);
        updateArtist(meta);
    }

    Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: title
            fontSize: "large"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: album
            color: "#AAA"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: artist
            color: "#AAA"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    function updateTitle(meta)
    {
        if (meta && meta.title) {
            title.text = meta.title;
        } else {
            title.text = "";
        }
    }

    function updateAlbum(meta)
    {
        if (meta && meta.album) {
            album.text = meta.album;
        } else {
            album.text = "";
        }
    }

    function updateArtist(meta)
    {
        if (meta && meta.artist) {
            artist.text = meta.artist;
        } else {
            artist.text = "";
        }
    }

}
