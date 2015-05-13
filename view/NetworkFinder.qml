import QtQuick 2.0

Timer {
    interval: 50
    repeat: true
    running: true
    triggeredOnStart: true
    property string host: ""
    property int maxEssay: 255
    property var hostArray: [192, 168, 0, 0]

    onTriggered: {
        host = nextHost();
        console.log("Try: "+ host);
        main.host = host;
        echo(main.statusUrl, host);
    }

    function echo(url, h)
    {
        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                host = h;
                running = false; // stop searching
                console.log("FOUND: "+ host);
            }
        }
        xhr.open("GET", url);
        xhr.send();
    }

    function nextHost()
    {
        next(3);

        if (hostArray[3] === 0)
        {
            next(2);

            if (hostArray[2] === 0) {
                running = false; // stop searching
            }
        }
        return createHost();
    }

    function next(idx)
    {
        if (hostArray[idx] < maxEssay) {
            hostArray[idx]++;
        } else {
            hostArray[idx] = 0;
        }
    }

    function createHost()
    {
        var host = hostArray[0];

        for (var i = 1; i < hostArray.length; i++) {
            host += "."+ hostArray[i];
        }
        return host;
    }
}

