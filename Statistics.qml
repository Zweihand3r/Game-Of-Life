import QtQuick 2.0

Rectangle {
    id: root
    width: 200
    height: 980
    color: "transparent"

    function updateStatistics() {
        generationText.text = '<font color="white">' + populationCount + '<font color="gray"> cells alive after <font color="white">' + generations + '<font color="gray"> generations'
    }

    function getPopulation() {
        populationCount = 0

        for (var index in grid) {
            if (grid[index].occupied) {
                populationCount++
            }
        }
    }

    function updatePopulation() {
        getPopulation()
        updateStatistics()
    }

    Rectangle {
        id: content
        x: -200
        width: 200
        height: 980
        color: "transparent"

        Behavior on x {
            NumberAnimation { duration: 240; easing.type: Easing.OutCurve }
        }

        Rectangle {
            anchors.fill: content
            color: "black"
            opacity: 0.86
        }

        Text {
            id: generationText
            x: 9
            y: 8
            width: 182
            height: 964
            color: "#ffffff"
            text: '<font color="white">0<font color="gray"> cells alive after <font color="white">0<font color="gray"> generations'
            wrapMode: Text.WordWrap
            font.pixelSize: 34
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: root
        hoverEnabled: true

        onEntered: {
            if (!menuActive) {
                content.x = 0
            }
        }

        onExited: {
            if (!menuActive) {
                content.x = -200
            }
        }
    }
}
