/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2013 Jonathan D'Orleans (jonathan.dorleans@gmail.com)
 * Licensed under the GNU GPLv3 licence (http://www.gnu.org/licenses/gpl-3.0.html)
 */

import QtQuick 2.4
import "jsonpath.js" as JSONPath

ListModel {
    property string json: ""
    property string query: ""
    property string source: ""
    property bool autoUpdateQuery: false
    property bool autoUpdateSource: true

    onJsonChanged: updateModel()
    onQueryChanged: {
        if (autoUpdateQuery) {
            updateModel();
        }
    }
    onSourceChanged: {
        if (autoUpdateSource) {
            request();
        }
    }

    function request()
    {
        var xhr = new XMLHttpRequest();

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                json = xhr.responseText;
            }
        }
        xhr.open("GET", source);
        xhr.send();
    }

    // to be overrided if needed
    function beforeUpdate() { }

    function afterUpdate() { }

    function updateModel()
    {
        beforeUpdate();
        clear();
        updateJSON();
        afterUpdate();
    }

    function updateJSON()
    {
        if (json !== "")
        {
            var jsonObject = parseJSON(json, query);

            for (var index in jsonObject) {
                append(jsonObject[index]);
            }
        }
    }

    function parseJSON(json, query)
    {
        var jsonObject = JSON.parse(json);

        if (query !== "") {
            jsonObject = JSONPath.jsonPath(jsonObject, query);
        }
        return jsonObject;
    }
}
