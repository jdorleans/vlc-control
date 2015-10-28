import QtQuick 2.4
import Ubuntu.Components 1.2

Rectangle {
    color: "#DD000000"
    height: column.height + units.gu(2)

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


    function updateInfos(meta) {
        updateTitle(meta);
        updateAlbum(meta);
        updateArtist(meta);
    }

    function updateTitle(meta)
    {
        if (meta && meta.title) {
            if (meta.title !== title.text) {
                title.text = meta.title;
            }
        } else {
            title.text = "";
        }
    }

    function updateAlbum(meta)
    {
        if (meta && meta.album) {
            if (meta.album !== album.text) {
                album.text = meta.album;
            }
        } else {
            album.text = "";
        }
    }

    function updateArtist(meta)
    {
        if (meta && meta.artist) {
            if (meta.artist !== artist.text) {
                artist.text = meta.artist;
            }
        } else {
            artist.text = "";
        }
    }

}
