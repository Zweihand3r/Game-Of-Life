import QtQuick 2.0

MouseArea {
    id: root
    width: 16
    height: 16
    hoverEnabled: true

    property int gridIndex: 0
    property bool occupied: false

    onEntered: if (previewMode) currentHoveredIndex = gridIndex
    onExited: if (previewMode) clearPreviewGrid()
    onClicked: {
        if (previewMode) {
            controls.setFromPreview()
        }
        else {
            grid[gridIndex].occupied = !grid[gridIndex].occupied
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: occupied ? 1 : 0
        border.color: "white"
    }
}
