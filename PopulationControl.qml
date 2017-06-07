import QtQuick 2.6
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import "./Colors.js" as Color

Rectangle {
    id: populationControl
    width: 476
    height: 448
    color: "transparent"

    property int previousSelectionIndex: 0

    function generatePopulation() {
        switch (previousSelectionIndex) {
        case 0: clearFillGeneration(); break
        case 1: reverseGeneration(); break
        case 2: randomGeneration(); break
        case 3: checkeredGeneration(); break
        case 4: stripeGeneration(); break
        case 5: gliderGunGeneration(24); break
        case 6: period3PulsarGeneration(4 + columns * 4); break
        case 7: period15PentadecathlonGeneration(4 + columns * 4); break
        }
    }

    function previewAction() {
        for (var index = 0; index < population.length; index++) {
            grid[index].occupied = false
        }

        previewMode = true
        menuActive = false

        transitionFromMenu.start()
        controls.dismiss()
        sidePanel.x = 1920

        donePreviewButton.opacity = 1
        donePreviewButton.scale = 1
    }

    function generatePreview() {
        switch (previousSelectionIndex) {
        case 5: gliderGunPreview(currentHoveredIndex); break
        case 6: period3PulsarPreview(currentHoveredIndex); break
        case 7: period15PentadecathlonPreview(currentHoveredIndex); break
        }
    }

    function setFromPreview() {
        switch (previousSelectionIndex) {
        case 5: gliderGunGeneration(currentHoveredIndex); break
        case 6: period3PulsarGeneration(currentHoveredIndex); break
        case 7: period15PentadecathlonGeneration(currentHoveredIndex); break
        }
    }

    function clearFillGeneration() {
        // If populationCount present change this
        var populate = true

        for (var index = 0; index < population.length; index++) {
            if (population[index]) {
                populate = false
                break
            }
        }

        for (index = 0; index < population.length; index++) {
            grid[index].occupied = populate
            population[index] = populate
        }
    }

    function reverseGeneration() {
        for (var index = 0; index < population.length; index++) {
            grid[index].occupied = !grid[index].occupied
            population[index] = !population[index]
        }
    }

    function checkeredGeneration() {
        var checkered = true

        for (var index = 0; index < population.length; index++) {
            var cell = grid[index]

            cell.occupied = checkered
            population[index] = checkered

            if (index % columns !== (columns - 1) && columns % 2 == 0) {
                checkered = !checkered
            }

            if (index % columns !== (columns) && columns % 2 == 1) {
                checkered = !checkered
            }
        }
    }

    function randomGeneration() {
        var seedKinda = Math.random() * 4 + 1

        for (var index = 0; index < population.length; index++) {
            var cell = grid[index]

            if (Math.random() > 1/seedKinda) {
                cell.occupied = false
                population[index] = false
            }
            else {
                cell.occupied = true
                population[index] = true
            }
            //            console1.write(index + " " + (population[index] ? "true" : "false"))
        }
    }

    function stripeGeneration() {
        var striped = (Math.random() * 4) < 2 ? true : false

        for (var index = 0; index < population.length; index++) {
            var cell = grid[index]

            cell.occupied = striped
            population[index] = striped

            if (index % columns !== (columns) && columns % 2 == 0) {
                striped = !striped
            }

            if (index % columns !== (columns - 1) && columns % 2 == 1) {
                striped = !striped
            }
        }
    }

    function gliderGunPreview(index) {
        index -= 24

        try {
            // First line
            selectorGrid[index + 24].occupied = true

            // Second line
            index += columns
            selectorGrid[index + 22].occupied = true
            selectorGrid[index + 24].occupied = true

            // Third line
            index += columns
            selectorGrid[index + 12].occupied = true
            selectorGrid[index + 13].occupied = true
            selectorGrid[index + 20].occupied = true
            selectorGrid[index + 21].occupied = true
            selectorGrid[index + 34].occupied = true
            selectorGrid[index + 35].occupied = true

            // Next line
            index += columns
            selectorGrid[index + 11].occupied = true
            selectorGrid[index + 15].occupied = true
            selectorGrid[index + 20].occupied = true
            selectorGrid[index + 21].occupied = true
            selectorGrid[index + 34].occupied = true
            selectorGrid[index + 35].occupied = true

            // Next line
            index += columns
            selectorGrid[index].occupied = true
            selectorGrid[index + 1].occupied = true
            selectorGrid[index + 10].occupied = true
            selectorGrid[index + 16].occupied = true
            selectorGrid[index + 20].occupied = true
            selectorGrid[index + 21].occupied = true

            // Next line
            index += columns
            selectorGrid[index].occupied = true
            selectorGrid[index + 1].occupied = true
            selectorGrid[index + 10].occupied = true
            selectorGrid[index + 14].occupied = true
            selectorGrid[index + 16].occupied = true
            selectorGrid[index + 17].occupied = true
            selectorGrid[index + 22].occupied = true
            selectorGrid[index + 24].occupied = true

            // Next line
            index += columns
            selectorGrid[index + 10].occupied = true
            selectorGrid[index + 16].occupied = true
            selectorGrid[index + 24].occupied = true

            // Next line
            index += columns
            selectorGrid[index + 11].occupied = true
            selectorGrid[index + 15].occupied = true

            // Next line
            index += columns
            selectorGrid[index + 12].occupied = true
            selectorGrid[index + 13].occupied = true
        }
        catch (error) {
            console.log(error + " at baseIndex - " + index)
        }
    }

    function gliderGunGeneration(index) {
        if ((rows < 8 || columns < 36) && !previewMode) {
            error.start()
            return
        }

        if (!previewMode) {
            for (var x = 0; x < grid.length; x++) {
                grid[x].occupied = false
            }
        }

        index -= 24

        // First line
        grid[index + 24].occupied = true

        // Second line
        index += columns
        grid[index + 22].occupied = true
        grid[index + 24].occupied = true

        // Third line
        index += columns
        grid[index + 12].occupied = true
        grid[index + 13].occupied = true
        grid[index + 20].occupied = true
        grid[index + 21].occupied = true
        grid[index + 34].occupied = true
        grid[index + 35].occupied = true

        // Next line
        index += columns
        grid[index + 11].occupied = true
        grid[index + 15].occupied = true
        grid[index + 20].occupied = true
        grid[index + 21].occupied = true
        grid[index + 34].occupied = true
        grid[index + 35].occupied = true

        // Next line
        index += columns
        grid[index].occupied = true
        grid[index + 1].occupied = true
        grid[index + 10].occupied = true
        grid[index + 16].occupied = true
        grid[index + 20].occupied = true
        grid[index + 21].occupied = true

        // Next line
        index += columns
        grid[index].occupied = true
        grid[index + 1].occupied = true
        grid[index + 10].occupied = true
        grid[index + 14].occupied = true
        grid[index + 16].occupied = true
        grid[index + 17].occupied = true
        grid[index + 22].occupied = true
        grid[index + 24].occupied = true

        // Next line
        index += columns
        grid[index + 10].occupied = true
        grid[index + 16].occupied = true
        grid[index + 24].occupied = true

        // Next line
        index += columns
        grid[index + 11].occupied = true
        grid[index + 15].occupied = true

        // Next line
        index += columns
        grid[index + 12].occupied = true
        grid[index + 13].occupied = true
    }

    function period3PulsarPreview(index) {
        // First Line
        selectorGrid[index + 2].occupied = true
        selectorGrid[index + 3].occupied = true
        selectorGrid[index + 4].occupied = true
        selectorGrid[index + 8].occupied = true
        selectorGrid[index + 9].occupied = true
        selectorGrid[index + 10].occupied = true

        // Second line
        index += columns * 2
        selectorGrid[index].occupied = true
        selectorGrid[index + 5].occupied = true
        selectorGrid[index + 7].occupied = true
        selectorGrid[index + 12].occupied = true

        // Third line
        index += columns
        selectorGrid[index].occupied = true
        selectorGrid[index + 5].occupied = true
        selectorGrid[index + 7].occupied = true
        selectorGrid[index + 12].occupied = true

        // Next line
        index += columns
        selectorGrid[index].occupied = true
        selectorGrid[index + 5].occupied = true
        selectorGrid[index + 7].occupied = true
        selectorGrid[index + 12].occupied = true

        // Next Line
        index += columns
        selectorGrid[index + 2].occupied = true
        selectorGrid[index + 3].occupied = true
        selectorGrid[index + 4].occupied = true
        selectorGrid[index + 8].occupied = true
        selectorGrid[index + 9].occupied = true
        selectorGrid[index + 10].occupied = true

        // Next Line
        index += columns * 2
        selectorGrid[index + 2].occupied = true
        selectorGrid[index + 3].occupied = true
        selectorGrid[index + 4].occupied = true
        selectorGrid[index + 8].occupied = true
        selectorGrid[index + 9].occupied = true
        selectorGrid[index + 10].occupied = true

        // Next line
        index += columns
        selectorGrid[index].occupied = true
        selectorGrid[index + 5].occupied = true
        selectorGrid[index + 7].occupied = true
        selectorGrid[index + 12].occupied = true

        // Next line
        index += columns
        selectorGrid[index].occupied = true
        selectorGrid[index + 5].occupied = true
        selectorGrid[index + 7].occupied = true
        selectorGrid[index + 12].occupied = true

        // Next line
        index += columns
        selectorGrid[index].occupied = true
        selectorGrid[index + 5].occupied = true
        selectorGrid[index + 7].occupied = true
        selectorGrid[index + 12].occupied = true

        // Next Line
        index += columns * 2
        selectorGrid[index + 2].occupied = true
        selectorGrid[index + 3].occupied = true
        selectorGrid[index + 4].occupied = true
        selectorGrid[index + 8].occupied = true
        selectorGrid[index + 9].occupied = true
        selectorGrid[index + 10].occupied = true
    }

    function period3PulsarGeneration(index) {
        if (!previewMode) {
            for (var x = 0; x < grid.length; x++) {
                grid[x].occupied = false
            }
        }

        // First Line
        grid[index + 2].occupied = true
        grid[index + 3].occupied = true
        grid[index + 4].occupied = true
        grid[index + 8].occupied = true
        grid[index + 9].occupied = true
        grid[index + 10].occupied = true

        // Second line
        index += columns * 2
        grid[index].occupied = true
        grid[index + 5].occupied = true
        grid[index + 7].occupied = true
        grid[index + 12].occupied = true

        // Third line
        index += columns
        grid[index].occupied = true
        grid[index + 5].occupied = true
        grid[index + 7].occupied = true
        grid[index + 12].occupied = true

        // Next line
        index += columns
        grid[index].occupied = true
        grid[index + 5].occupied = true
        grid[index + 7].occupied = true
        grid[index + 12].occupied = true

        // Next Line
        index += columns
        grid[index + 2].occupied = true
        grid[index + 3].occupied = true
        grid[index + 4].occupied = true
        grid[index + 8].occupied = true
        grid[index + 9].occupied = true
        grid[index + 10].occupied = true

        // Next Line
        index += columns * 2
        grid[index + 2].occupied = true
        grid[index + 3].occupied = true
        grid[index + 4].occupied = true
        grid[index + 8].occupied = true
        grid[index + 9].occupied = true
        grid[index + 10].occupied = true

        // Next line
        index += columns
        grid[index].occupied = true
        grid[index + 5].occupied = true
        grid[index + 7].occupied = true
        grid[index + 12].occupied = true

        // Next line
        index += columns
        grid[index].occupied = true
        grid[index + 5].occupied = true
        grid[index + 7].occupied = true
        grid[index + 12].occupied = true

        // Next line
        index += columns
        grid[index].occupied = true
        grid[index + 5].occupied = true
        grid[index + 7].occupied = true
        grid[index + 12].occupied = true

        // Next Line
        index += columns * 2
        grid[index + 2].occupied = true
        grid[index + 3].occupied = true
        grid[index + 4].occupied = true
        grid[index + 8].occupied = true
        grid[index + 9].occupied = true
        grid[index + 10].occupied = true
    }

    function period15PentadecathlonPreview(index) {
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index - 1].occupied = true
        selectorGrid[index + 1].occupied = true

        index += columns
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index - 1].occupied = true
        selectorGrid[index + 1].occupied = true

        index += columns
        selectorGrid[index].occupied = true

        index += columns
        selectorGrid[index].occupied = true
    }

    function period15PentadecathlonGeneration(index) {
        if (!previewMode) {
            for (var x = 0; x < grid.length; x++) {
                grid[x].occupied = false
            }
        }

        grid[index].occupied = true

        index += columns
        grid[index].occupied = true

        index += columns
        grid[index - 1].occupied = true
        grid[index + 1].occupied = true

        index += columns
        grid[index].occupied = true

        index += columns
        grid[index].occupied = true

        index += columns
        grid[index].occupied = true

        index += columns
        grid[index].occupied = true

        index += columns
        grid[index - 1].occupied = true
        grid[index + 1].occupied = true

        index += columns
        grid[index].occupied = true

        index += columns
        grid[index].occupied = true
    }

    Rectangle {
        id: mask
        width: 476
        height: 368
        radius: 24
        opacity: 0
    }

    Item {
        id: listFrame
        width: 476
        height: 368
        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }

        Rectangle {
            width: 476
            height: 368
            color: Color.transparent
            border.color: Color.white
            border.width: 4
            radius: 24

            ListView {
                id: listView
                y: 4
                width: 476
                height: 360
                delegate: PopulationDelagate {
                    title: name
                    selected: selection

                    onCellSelected: {
                        listModel.setProperty(previousSelectionIndex, "selection", false)
                        listModel.setProperty(index, "selection", true)

                        if (index >= 5) {
                            populationControl.state = 'gridSetter'
                        }
                        else {
                            populationControl.state = ''
                        }

                        previousSelectionIndex = index
                    }
                }

                spacing: 6

                model: ListModel {
                    id: listModel
                    ListElement { name: "Fill/Clear"; selection: true }
                    ListElement { name: "Reverse"; selection: false }
                    ListElement { name: "Random"; selection: false }
                    ListElement { name: "Checkered"; selection: false }
                    ListElement { name: "Striped"; selection: false }
                    ListElement { name: "Glider Gun"; selection: false }
                    ListElement { name: "Period 3 Pulsar"; selection: false }
                    ListElement { name: "Period 15 Pentadecathlon"; selection: false }
                }
            }
        }
    }

    Rectangle {
        id: buttonMask
        y: 378
        width: 476
        height: 70
        opacity: 0
        radius: 16
    }

    Item {
        id: item1
        y: 378
        width: 476
        height: 70
        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: buttonMask
        }

        CustomButton {
            id: populateButton
            width: 476
            height: 70
            cornerRadius: 0
            text: "Populate"
            onClicked: generatePopulation()
        }

        CustomButton {
            id: setInGridButton
            width: 234
            height: 70
            cornerRadius: 0
            text: "Set in Grid"
            anchors.left: populateButton.right
            anchors.leftMargin: 8
            onClicked: previewAction()
        }
    }

    states: [
        State {
            name: "gridSetter"

            PropertyChanges {
                target: populateButton
                width: 234
                buttonFont: 35
            }

            PropertyChanges {
                target: setInGridButton
                buttonFont: 35
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "width, buttonFont"
                duration: 120
                easing.type: Easing.OutQuad
            }
        }
    ]

//    CustomComboBox {
//        id: customComboBox
//        x: 0
//        y: 98
//        width: 400
//        height: 70
//        model: ["Random", "Checkered", "Striped", "Glider Gun"]
//    }

    Behavior on opacity {
        OpacityAnimator { duration: 160; easing: Easing.InQuad }
    }
}
