import QtQuick 2.0

Image {
    fillMode: Image.PreserveAspectFit
    property int volJump: 3
    property int timeJump: 5
    property double moveFactor: 0.1
    property double swipeFactor: 0.6
    property int minMoveX: parent.width*moveFactor
    property int minMoveY: parent.height*moveFactor
    property int minSwipeX: parent.width*swipeFactor
    property int minSwipeY: parent.height*swipeFactor
    property var currentArt: null

    signal click

    signal moveUp
    signal moveDown
    signal moveLeft
    signal moveRight

    signal swipeUp
    signal swipeDown
    signal swipeLeft
    signal swipeRight

    Timer {
        id: updater
        repeat: true
        interval: 100
        onTriggered: mouseArea.updateMove()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property int startX: 0
        property int startY: 0

        onClicked: click()

        // TODO - What to do when double clicked?
        // ideias: stop, next...
        // onDoubleClicked: { ??? }

        onPressed: {
            startX = mouseX;
            startY = mouseY;
        }
        onPressAndHold: updater.running = true

        onReleased: {
            updater.running = false;
            updateSwipe();
        }

        function updateMove()
        {
            var deltaX = mouseX-startX;
            var deltaY = mouseY-startY;

            if (Math.abs(deltaX) > minMoveX)
            {
                if (mouseX > startX) {
                    moveRight();
                } else {
                    moveLeft();
                }
            }
            else if (Math.abs(deltaY) > minMoveY)
            {
                if (mouseY < startY) {
                    moveUp();
                } else {
                    moveDown();
                }
            }
        }

        function updateSwipe()
        {
            var deltaX = mouseX-startX;
            var deltaY = mouseY-startY;

            if (Math.abs(deltaX) > minSwipeX)
            {
                if (deltaX > 0) {
                    swipeRight();
                } else {
                    swipeLeft();
                }
            }
            else if (Math.abs(deltaY) > minSwipeY)
            {
                if (deltaY > 0) {
                    swipeUp();
                } else {
                    swipeDown();
                }
            }
        }
    }


    function updateCoverArt(meta)
    {
        if (meta && meta.artwork_url) {
            if (currentArt !== meta.artwork_url) {
                currentArt = meta.artwork_url;
                source = main.baseUrl +"art?"+ new Date();
            }
        } else {
            currentArt = null;
            source = ""; // TODO Add image for 'CoverArt not Found'
        }
    }

}
