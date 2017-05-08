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
        case 0: randomGeneration(); break
        case 1: checkeredGeneration(); break
        case 2: stripeGeneration(); break
        case 3: gliderGunGeneration(0); break
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
        for (var index = 0; index < population.length; index++) {
            var cell = grid[index]

            if (Math.random() > 1/3) {
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

    function gliderGunGeneration(index) {
        if (rows < 8 || columns < 36) {
            error.start()
            return
        }

        for (var x = 0; x < grid.length; x++) {
            grid[x].occupied = false
        }

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

    CustomButton {
        id: populateButton
        y: 378
        width: 476
        height: 70
        text: "Populate"
        onClicked: generatePopulation()
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

                        previousSelectionIndex = index
                    }
                }

                spacing: 6

                model: ListModel {
                    id: listModel
                    ListElement { name: "Random"; selection: true }
                    ListElement { name: "Checkered"; selection: false }
                    ListElement { name: "Striped"; selection: false }
                    ListElement { name: "Glider Gun"; selection: false }
                }
            }
        }
    }

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
