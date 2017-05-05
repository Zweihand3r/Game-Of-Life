import QtQuick 2.0
import QtQuick.Controls 2.0

import "./Colors.js" as Color

Rectangle {
    id: root
    height: 172
    width: 172 * 4
    color: Color.transparent

    RuleSetButton {

    }

    RuleSetButton {
        x: 192
        y: 0
    }

    RuleSetButton {
        x: 384
        y: 0
    }
}
