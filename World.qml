import QtQuick 2.6
import QtQuick.Controls 2.0

import "./Colors.js" as Color

Rectangle {
    id: root
    width: 1920
    height: 980
    color: "black"

    property bool debug: false

    property bool worldActive: false
    property bool playActive: false
    property bool menuActive: false
    property bool colorPaletteHovered: false
    property bool previewMode: false
    property bool gridHighlight: false

    property int rows // 54 Max
    property int columns // 105 Max
    property int gridSpacing: 2
    property int cycleInterval: 160
    property int generations: 0
    property int populationCount: 0
    property bool animate: true

    property string inputString: "0"

    property var grid: []
    property var selectorGrid: []
    property var population: []
    property var shades: []
    property var ages: []

    property var survivalRules: [2, 3]
    property var growthRules: [3]

    property int currentHoveredIndex: 0
    property int generationProcessIndex: 0
    property int resetProcessIndex: 0
    property int colorGenerationIndex: 0

    onCurrentHoveredIndexChanged: {
        if (previewMode) {
            controls.generatePreview()
        }
    }

    function generateWorld() {
        var index = 0
        var rowPosition = 0
        var colPosition = 0
        var radius = controls.selectedShape === "cir" ? 8 : 0
        var rotation = controls.selectedShape === "dia" ? 45 : 0

        var componentId = debug ? "DebugCell.qml" : "Cell.qml"

        populationCount = 0

        for (var row = 0; row < rows; row++) {
            for (var col = 0; col < columns; col++) {
                var component = Qt.createComponent(componentId)

                if (debug) {
                    var newCell = component.createObject(worldGrid, {"x":rowPosition, "y":colPosition, "occupied":true, "index":index, "animate":animate})
                }
                else {
                    newCell = component.createObject(worldGrid, {"x":rowPosition, "y":colPosition, "radius":radius, "rotation":rotation, "occupied":false, "animate":true})
                }

                grid.splice(index, 0, newCell)
                population.splice(index, 0, true)
                ages.splice(index, 0, 0)

                index++
                populationCount++
                rowPosition += debug ? 32 + gridSpacing : 16 + gridSpacing
            }

            colPosition += debug ? 32 + gridSpacing : 16 + gridSpacing
            rowPosition = 0
        }

        if (!debug) {
            worldGrid.width = (16 + gridSpacing) * (columns)
            worldGrid.height = (16 + gridSpacing) * (rows)

            generationProcess()
        }
        else {
            worldGrid.anchors.fill = root
        }

        stats.updateStatistics()
    }

    function toggleSelector(toggle) {
        if (toggle) {
            var index = 0
            var rowPosition = 0
            var colPosition = 0
            var radius = controls.selectedShape === "cir"
            var rotation = controls.selectedShape === "dia"

            var componentId = "SelectorCell.qml"

            for (var row = 0; row < rows; row++) {
                for (var col = 0; col < columns; col++) {
                    var component = Qt.createComponent(componentId)
                    var selectorCell = component.createObject(worldGrid, { "x":rowPosition, "y":colPosition, "isCircle":radius, "isDiamond":rotation, "gridIndex": index })

                    selectorGrid.splice(index, 0, selectorCell)

                    index++
                    rowPosition += debug ? 32 + gridSpacing : 16 + gridSpacing
                }

                colPosition += debug ? 32 + gridSpacing : 16 + gridSpacing
                rowPosition = 0
            }
        }
        else {
            for (index = 0; index < grid.length; index++) {
                selectorCell = selectorGrid[index]
                selectorCell.destroy()
            }

            selectorGrid = []
        }
    }

    function toggleSelectorHighlight(toggle) {
        for (var index in selectorGrid) {
            selectorGrid[index].occupied = toggle
        }
    }

    function generationProcess() {
        for (var index = generationProcessIndex; index < grid.length; index += columns) {
            grid[index].occupied = true
        }

        generationProcessIndex++

        if (generationProcessIndex < columns) {
            generationIntervalClock.start()
        }
        else {
            // Generation completes here
            worldActive = true
            toggleSelector(true)

            generationProcessIndex = 0
            setAnimation(animate)

            controls.generationCompletion()
        }
    }

    function recycleWorld() {
        worldActive = false
        toggleSelector(false)

        generations = 0
        populationCount = 0

        if (playActive) {
            playActive = false

            sidepanel.setPause()
            worldClock.stop()
        }

        setAnimation(true)
        resetProcess()

        stats.updateStatistics()
    }

    function resetProcess() {
        for (var index = resetProcessIndex; index < grid.length; index += columns) {
            grid[index].occupied = false
        }

        resetProcessIndex++

        if (resetProcessIndex < columns - 1) {
            resetIntervalClock.start()
        }
        else {
            resetProcessIndex = 0

            // Actual destruction process
            completeReset.start()
        }
    }

    function resetCompletion() {
        for (var index = 0; index < grid.length; index++) {
            var cell = grid[index]
            cell.destroy()
        }

        grid = []
        population = []

        setAnimation(animate)
        controls.resetCompletion()
    }

    function incrementCycle() {
        var newGeneration = []

        for (var index = 0; index < population.length; index++) {
            var survivalIndex = 0
            var growthIndex = 0
            var counter = false

            if (hasTopNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasTopRightNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasRightNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasBottomRightNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasBottomNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasBottomLeftNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasLeftNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasTopLeftNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (population[index]) {
                for (var index2 in survivalRules) {
                    if (survivalIndex === survivalRules[index2]) {
                        counter = true
                        break
                    }
                }
            }
            else {
                for (index2 in growthRules) {
                    if (growthIndex === growthRules[index2]) {
                        counter = true
                        break
                    }
                }
            }

            if (colorPalette.paletteIndex === 1) {
                if (!counter) {
                    ages[index] = 0
                    grid[index].color = shades[ages[index]]
                }
                else {
                    if (ages[index] < shades.length - 1) {
                        ages[index]++
                        grid[index].color = shades[ages[index]]
                    }
                }
            }

            newGeneration.splice(index, 0, counter)

            population[index] = newGeneration[index]
        }

        populationCount = 0
        for (index = 0; index < newGeneration.length; index++) {
            var cellInTransition = grid[index]
            cellInTransition.occupied = newGeneration[index]

            if (cellInTransition.occupied) {
                populationCount++
            }
        }

        generations++
        stats.updateStatistics()
    }

    function incrementCycleOld() {
        var newGeneration = []

        for (var index = 0; index < population.length; index++) {
            var survivalIndex = 0
            var growthIndex = 0

            if (hasTopNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasTopRightNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasRightNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasBottomRightNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasBottomNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasBottomLeftNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasLeftNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            if (hasTopLeftNeighbour(index)) {
                survivalIndex++
                growthIndex++
            }

            //            console1.write("-~-")
            //            console1.write(index + " " + (population[index] ? "OCCUPIED" : "VACANT"))

            if (population[index]) {
                //                console1.write(index + " SI: " + survivalIndex)
                switch (survivalIndex) {
                case 2:
                case 3:
                    newGeneration.splice(index, 0, true)
                    //                    console1.write(index + " -> OCCUPIED")
                    break

                default:
                    newGeneration.splice(index, 0, false)
                    //                    console1.write(index + "-> VACANT")
                }
            }
            else {
                //                console1.write(index + " GI: " + growthIndex)
                if (growthIndex === 3) {
                    newGeneration.splice(index, 0, true)
                    //                    console1.write(index + "-> OCCUPIED")
                }
                else {
                    newGeneration.splice(index, 0, false)
                    //                    console1.write(index + "-> VACANT")
                }
            }
            //            console1.write("*******************************************************")

            population[index] = newGeneration[index]
        }

        for (index = 0; index < newGeneration.length; index++) {
            var cellInTransition = grid[index]
            cellInTransition.occupied = newGeneration[index]
        }
    }

    function play() {
        for (var index = 0; index < population.length; index++) {
            var cell = grid[index]
            population[index] = cell.occupied
        }

        worldClock.start()
    }

    function advance() {
        for (var index = 0; index < population.length; index++) {
            var cell = grid[index]
            population[index] = cell.occupied
        }

        incrementCycle()
    }

    function colorGenerationProcess() {
        if (shades.length >= rows * columns) {
            for (var index = colorGenerationIndex; index < grid.length; index += columns) {
                grid[index].color = shades[index]
            }
        }
        else {
            switch (colorPalette.paletteIndex) {
            case 1:
                if (playActive) {
                    for (index = colorGenerationIndex; index < grid.length; index++) {
                        grid[index].color = shades[0]
                    }
                    return
                }
                else {
                    for (index = colorGenerationIndex; index < grid.length; index += columns) {
                        grid[index].color = shades[0]
                    }
                    break
                }

            case -1:
            case 2:
                for (index = colorGenerationIndex; index < grid.length; index += columns) {
                    grid[index].color = shades[index % columns]
                }
                break
            }
        }

        colorGenerationIndex++

        if (colorGenerationIndex < columns) {
            colorGeneratorTimer.start()
        }
        else {
            // Generation Comletion
            colorGenerationIndex = 0
        }
    }

    function setAnimation(animationStatus) {
        for (var index = 0; index < grid.length; index++) {
            var cell = grid[index]
            cell.animate = animationStatus
        }
    }

    function hasTopNeighbour(index) {
        if (index >= columns) {
            //            console1.write(index + " Top ")
            if (grid[index - columns].occupied) {
                return true
            }
        }

        return false
    }

    function hasBottomNeighbour(index) {
        if (index <= (rows * columns - columns - 1)) {
            //            console1.write(index + " Bottom ")
            if (grid[index + columns].occupied) {
                return true
            }
        }

        return false
    }

    function hasLeftNeighbour(index) {
        if (index % columns !== 0) {
            //            console1.write(index + " Left ")
            if (grid[index - 1].occupied) {
                return true
            }
        }

        return false
    }

    function hasRightNeighbour(index) {
        if (index % columns !== (columns - 1)) {
            //            console1.write(index + " Right ")
            if (grid[index + 1].occupied) {
                return true
            }
        }

        return false
    }

    function hasTopLeftNeighbour(index) {
        if (index >= columns && index % columns !== 0) {
            //            console1.write(index + " Top Left ")
            if (grid[index - columns - 1].occupied) {
                return true
            }
        }

        return false
    }

    function hasTopRightNeighbour(index) {
        if (index >= columns && index % columns !== (columns - 1)) {
            //            console1.write(index + " Top Right ")
            if (grid[index - columns + 1].occupied) {
                return true
            }
        }

        return false
    }

    function hasBottomRightNeighbour(index) {
        if (index <= (rows * columns - columns - 1) && index % columns !== (columns - 1)) {
            //            console1.write(index + " Bottom Right ")
            if (grid[index + columns + 1].occupied) {
                return true
            }
        }

        return false
    }

    function hasBottomLeftNeighbour(index) {
        if (index <= (rows * columns - columns - 1) && index % columns !== 0) {
            //            console1.write(index + " Bottom Left ")
            if (grid[index + columns - 1].occupied) {
                return true
            }
        }

        return false
    }

    function clearPreviewGrid() {
        for (var x = 0; x < grid.length; x++) {
            selectorGrid[x].occupied = false
        }
    }

    function dummyDirection() {
        var index = parseInt(inputString)

        console1.write("Top Neighbour ? " + hasTopNeighbour(index))
        if (index >= columns) {
            console1.write("Up from gird index " + index + " : " + (index - columns) + ". ")
        }

        console1.write("Bottom Neighbour ? " + hasBottomNeighbour(index))
        if (index <= (rows * columns - rows - 1)) {
            console1.write("Down from gird index " + index + " : " + (index + columns) + ". ")
        }

        console1.write("Left Neighbour ? " + hasLeftNeighbour(index))
        if (index % columns !== 0) {
            console1.write("Left from gird index " + index + " : " + (index - 1) + ". ")
        }

        console1.write("Right Neighbour ? " + hasRightNeighbour(index))
        if (index % columns !== columns - 1) {
            console1.write("Right from gird index " + index + " : " + (index + 1) + ".")
        }

        console1.write("---------------------------------")
        console1.write("TopLeft Neighbour ? " + hasTopLeftNeighbour(index))
        console1.write("TopRight Neighbour ? " + hasTopRightNeighbour(index))
        console1.write("BottomRight Neighbour ? " + hasBottomRightNeighbour(index))
        console1.write("BottomLeft Neighbour ? " + hasBottomLeftNeighbour(index))
        console1.write("---------------------------------")
    }

    Component.onCompleted: {
        generateWorld()
        console.log("OnComplete called")
    }

    Timer {
        id: worldClock
        running: false
        repeat: true
        interval: cycleInterval
        onTriggered: incrementCycle()
    }

    Timer {
        id: generationIntervalClock
        repeat: false
        running: false
        interval: columns < 40 ? 30 : 10
        onTriggered: generationProcess()
    }

    Timer {
        id: resetIntervalClock
        repeat: false
        running: false
        interval: columns < 40 ? 30 : 10
        onTriggered: resetProcess()
    }

    Timer {
        id: completeReset
        repeat: false
        running: false
        interval: 88
        onTriggered: resetCompletion()
    }

    Timer {
        id: colorGeneratorTimer
        repeat: false
        running: false
        interval: columns < 40 ? 30 : 10
        onTriggered: colorGenerationProcess()
    }

    Rectangle {
        id: worldGrid
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Sidepanel {
        id: sidepanel
        x: 1720
        y: 0
    }

    Controls {
        id: controls
        opacity:  0
        scale:  0.98

        currentRowIndex: initialRowCount
        currentColumnIndex: initialColumnCount

        onRowSelected: rows = row
        onColumnSelected: columns = column
        onReset: recycleWorld()
        onGeneration: generateWorld()
        onAnimationEnabled: { setAnimation(status); animate = status }
        onIntervalGenerated: cycleInterval = interval
        onSpacingSelected: gridSpacing = spacing
        onHighlightGridSwitched: { gridHighlight = highlight; toggleSelectorHighlight(highlight) }
    }

    ColorPalette {
        id: colorPalette

        onColorsGenerated: {
            shades = colorArray
            colorGenerationProcess()
        }
    }

    Statistics {
        id: stats
    }

    CustomButton {
        id: donePreviewButton
        x: 864
        y: 944
        width: 72
        height: 28
        cornerRadius: 8
        buttonFont: 19
        text: "Done"
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0
        scale: 0.8

        onClicked: {
            previewMode = false

            opacity = 0
            scale = 0.8
            sidepanel.presentSidepanel()

            if (gridHighlight) toggleSelectorHighlight(true)
        }

        Behavior on opacity {
            OpacityAnimator { duration: 120 }
        }

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }


    ColorAnimation on color {
        id: error
        running: false
        from: "red"
        to: "black"
        duration: 640
    }
}
