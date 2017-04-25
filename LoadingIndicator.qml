import QtQuick 2.6

Rectangle {
    signal presented()
    signal dismissed()

    property int customRadius: 32
    property string customColor: "white"
    property int animationInterval: 240

    property int loadIndex: 0

    id: root
    height: customRadius
    width: (customRadius * 3) + (customRadius * 0.8)
    opacity: 0
    color: "transparent"

    Behavior on opacity {
        OpacityAnimator { duration: 80 }
    }

    function showLoading() {
        if (!loadInterval.running) {
            loadInterval.start()
            root.opacity = 1

            root.presented()
        }

        switch (loadIndex) {
        case 0:
            load1.scale = 1
            break

        case 1:
            load2.scale = 1
            break

        case 2:
            load3.scale = 1
            break

        case 3:
            load1.scale = 0
            break

        case 4:
            load2.scale = 0
            break

        case 5:
            load3.scale = 0
            break
        }

        if (loadIndex === 5) {
            loadIndex = 0
        }
        else {
            loadIndex++
        }
    }

    function hideLoading() {
        load1.scale = 0
        load2.scale = 0
        load3.scale = 0

        loadInterval.stop()
        loadIndex = 0

        root.opacity = 0
        root.dismissed()
    }

    Timer {
        id: loadInterval
        repeat: true
        running: false
        interval: animationInterval
        onTriggered: showLoading()
    }

    Rectangle {
        id: load1
        width: customRadius
        height: customRadius
        radius: customRadius / 2
        scale: 0
        color: customColor

        Behavior on scale {
            ScaleAnimator { duration: animationInterval }
        }
    }

    Rectangle {
        id: load2
        x: customRadius + (customRadius * 0.4)
        width: customRadius
        height: customRadius
        radius: customRadius / 2
        scale: 0
        color: customColor

        Behavior on scale {
            ScaleAnimator { duration: animationInterval }
        }
    }

    Rectangle {
        id: load3
        x: (customRadius * 2) + (customRadius * 0.8)
        width: customRadius
        height: customRadius
        radius: customRadius / 2
        scale: 0
        color: customColor

        Behavior on scale {
            ScaleAnimator { duration: animationInterval }
        }
    }
}
