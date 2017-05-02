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
    // * Random gradient
    // Info
    // Populate Pulsars

    property int initialRowCount: 32
    property int initialColumnCount: 64

    World {
        rows: initialRowCount
        columns: initialColumnCount
    }
}
