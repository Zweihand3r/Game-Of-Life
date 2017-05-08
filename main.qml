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
    // * Random gradient
    // Info
    // Populate Pulsars
    // Colors based on age of cell. 1 cycle alive blue, 2 cycles alive green, 3 cycles alive red
    // Cycle counter and population counter below play. Maybe even graph between cycle and population
    //
    // PUT MOAR SHAPES
    //

    property int initialRowCount: 32
    property int initialColumnCount: 64

    World {
        rows: initialRowCount
        columns: initialColumnCount
    }
}
