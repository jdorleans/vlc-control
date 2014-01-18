import QtQuick 2.0
import "../../view"

Row {
    spacing: units.gu(1);
    property int size: 64
    property bool isPlaying: false
    property string imgPath: "../../img/";

    signal clickPlay
    signal clickPause
    signal clickStop
    signal clickNext
    signal clickPrev

    Component.onCompleted: {
        for (var i = 0; i < children.length; i++) {
            children[i].size = size;
            children[i].timer.running = false;
        }
    }

    JButton {
        source: imgPath +"prev.png"
        onClick: clickPrev();
    }
    JButton {
        source: imgPath +"stop.png"
        onClick: clickStop();
    }
    JButton {
        source: imgPath +"play.png"
        visible: !isPlaying
        onClick: clickPlay();
    }
    JButton {
        source: imgPath +"pause.png"
        visible: isPlaying

        onClick: clickPause();
    }
    JButton {
        source: imgPath +"next.png"

        onClick: clickNext();
    }

}
