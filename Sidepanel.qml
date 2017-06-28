import QtQuick 2.6

import "./Colors.js" as Color

Rectangle {
    id: sidePanel
    width: 200
    height: 980
    color: "transparent"
    clip: true

    function transitionFromMenu() {
        transitionFromMenu.start()
    }

    function playTransition() {
        playText.text = playActive ? "PAUSE" : "PLAY"
        playTextTransitionPhaseII.start()
    }

    function setPause() {
        playTextTransitionPhaseI.start()
        transitionToPause.start()
    }

    function dismissSidepanel() {
        sidepanelContent.x = 200
    }

    Rectangle {
        id: sidepanelContent
        x: 200
        width: 200
        height: 980
        color: "transparent"

        Behavior on x {
            NumberAnimation { duration: 240; easing.type: Easing.OutCurve }
        }

        Rectangle {
            anchors.fill: sidepanelContent
            color: "black"
            opacity: 0.86
        }

        // Menu

        Text {
            id: menuText
            x: 64
            y: 138
            width: 128
            height: 56
            color: "#ffffff"
            text: "MENU"
            font.pixelSize: 40
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }
        }

        Text {
            id: closeIndicator
            x: 18
            y: 138
            width: 34
            height: 56
            color: Color.redTint
            text: "X"
            scale: 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
        }

        Text {
            id: menuIndicator
            x: 18
            y: 136
            width: 34
            height: 56
            color: "#ffffff"
            text: "<"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
        }

        ParallelAnimation {
            id: transitionToMenu
            running: false

            NumberAnimation {
                target: menuIndicator
                property: "x"
                from: 16
                to: -34
                duration: 120
            }

            ScaleAnimator {
                target: closeIndicator
                from: 0
                to: 0.75
                duration: 120
            }
        }

        ParallelAnimation {
            id: transitionFromMenu
            running: false

            NumberAnimation {
                target: menuIndicator
                property: "x"
                from: 66
                to: 16
                duration: 120
            }

            OpacityAnimator {
                target: menuIndicator
                from: 0
                to: 1
                duration: 120
            }

            ScaleAnimator {
                target: closeIndicator
                from: 0.75
                to: 0
                duration: 120
            }
        }

        // Play

        Text {
            id: playText
            x: 64
            y: 785
            width: 128
            height: 56
            color: "#ffffff"
            text: "PLAY"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }
        }

        Text {
            id: pauseIndicator
            x: 18
            y: 783
            width: 34
            height: 56
            color: "#ffffff"
            text: "||"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            scale: 0
            font.pixelSize: 40
        }

        Text {
            id: playIndicator
            x: 18
            y: 783
            width: 34
            height: 56
            color: "#ffffff"
            text: ">"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
        }

        Rectangle {
            id: colorTextFrame
            x: 65
            y: 450
            width: 127
            height: 81
            color: "transparent"

            Text {
                x: 0
                y: 0
                width: 111
                height: 56
                color: "#ffffff"
                text: "COLOR"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 34
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                x: 0
                y: 37
                width: 111
                height: 37
                color: "#ffffff"
                text: "PALETTE"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 27
                horizontalAlignment: Text.AlignLeft
            }

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }
        }

        Rectangle {
            x: 34
            y: 490
            width: 16
            height: 16
            radius: 8
            color: colorPaletteHovered ? Color.blueTint : "white"

            Behavior on color {
                ColorAnimation { duration: 120 }
            }
        }

        Rectangle {
            x: 34
            y: 473
            width: 16
            height: 16
            radius: 8
            color: colorPaletteHovered ? Color.greenTint : "white"

            Behavior on color {
                ColorAnimation { duration: 120 }
            }
        }

        Rectangle {
            x: 19
            y: 482
            width: 16
            height: 16
            radius: 8
            color: colorPaletteHovered ? Color.redTint : "white"

            Behavior on color {
                ColorAnimation { duration: 120 }
            }
        }

        ParallelAnimation {
            id: transitionToPlay
            running: false

            NumberAnimation {
                target: playIndicator
                property: "x"
                from: 16
                to: 66
                duration: 120
            }

            OpacityAnimator {
                target: playIndicator
                from: 1
                to: 0
                duration: 120
            }

            ScaleAnimator {
                target: pauseIndicator
                from: 0
                to: 0.75
                duration: 120
            }
        }

        ParallelAnimation {
            id: transitionToPause
            running: false

            NumberAnimation {
                target: playIndicator
                property: "x"
                from: -34
                to: 16
                duration: 120
            }

            OpacityAnimator {
                target: playIndicator
                from: 0
                to: 1
                duration: 60
            }

            ScaleAnimator {
                target: pauseIndicator
                from: 0.75
                to: 0
                duration: 120
            }
        }

        ParallelAnimation {
            id: playTextTransitionPhaseI
            OpacityAnimator {
                target: playText
                from: 1
                to: 0
                duration: 80
            }

            ScaleAnimator {
                target: playText
                from: 1.1
                to: 0.9
                duration: 80
            }

            onStopped: playTransition()
        }

        ParallelAnimation {
            id: playTextTransitionPhaseII
            OpacityAnimator {
                target: playText
                from: 0
                to: 1
                duration: 80
            }

            ScaleAnimator {
                target: playText
                from: 0.9
                to: 1.1
                duration: 80
            }
        }
    }

    MouseArea {
        id: menuMouse
        y: 0
        width: 200
        height: 327
        hoverEnabled: true

        onEntered: {
            if (!previewMode) {
                menuText.scale = 1.1
                sidepanelContent.x = 0
            }
        }

        onExited: {
            menuText.scale = 1
            if (!menuActive) {
                sidepanelContent.x = 200
            }
        }

        onPressed: {
            menuText.scale = 1.05

            if (!menuActive) {
                colorPalette.dismissPalette()

                menuActive = true

                transitionToMenu.start()
                controls.present()
            }
            else {
                menuActive = false

                transitionFromMenu.start()
                controls.dismiss()
            }
        }
        onReleased: menuText.scale = 1.1
    }

    MouseArea {
        id: colorMouse
        y: 327
        width: 200
        height: 327
        hoverEnabled: true

        onEntered: {
            if (worldActive && !previewMode) {
                colorPaletteHovered = true
                colorTextFrame.scale = 1.1
                sidepanelContent.x = 0
            }
        }

        onExited: {
            colorPaletteHovered = false
            colorTextFrame.scale = 1

            if (!menuActive) {
                sidepanelContent.x = 200
            }
        }

        onPressed: {
            if (worldActive) {
                if (menuActive) {
                    menuActive = false

                    transitionFromMenu.start()
                    controls.dismiss()
                }

                colorPalette.presentPalette()
                colorTextFrame.scale = 1.05
            }
        }

        onReleased: colorTextFrame.scale = worldActive ? 1.1 : 1
    }

    MouseArea {
        id: playMouse
        y: 654
        width: 200
        height: 326
        hoverEnabled: true

        onEntered: {
            if (worldActive && !previewMode) {
                playText.scale = 1.1
                sidepanelContent.x = 0
            }
        }

        onExited: {
            playText.scale = 1
            if (!menuActive) {
                sidepanelContent.x = 200
            }
        }

        onPressed: {
           if (worldActive) {
               playTextTransitionPhaseI.start()

               if (!playActive) {
                   playActive = true

                   transitionToPlay.start()
                   play()
               }
               else {
                   playActive = false

                   transitionToPause.start()
                   worldClock.stop()
               }
           }
        }
    }

}
