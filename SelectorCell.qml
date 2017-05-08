import QtQuick 2.0

MouseArea {
    id: root
    width: 16
    height: 16

    property int gridIndex: 0

    onClicked: grid[gridIndex].occupied = !grid[gridIndex].occupied
}
