import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 1920
    height: 980
    title: qsTr("The Game Of Life")

    // Cyclic World
    // Day n Night Rules
    // Color Palette
    // Info
    // Populate Pulsars

    property int initialRowCount: 32
    property int initialColumnCount: 64

    property bool isCp: true

    World {
        rows: initialRowCount
        columns: initialColumnCount
    }

    ColorPalette {
        id: cp
    }

    Button {
        onClicked: {
            if (!isCp) {
                isCp = true
                cp.presentPalette()
            }
            else {
                isCp = false
                cp.dismissPalette()
            }
        }
    }
}
