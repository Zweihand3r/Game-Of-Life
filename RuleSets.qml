import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import "./Colors.js" as Color

Rectangle {
    id: root
    height: 172
    width: 1032
    color: Color.transparent

    function selectRule(index) {
        lifeRule.selected = index === 0
        replicatorRule.selected = index === 1
        seedsRule.selected = index === 2
        namelessRule.selected = index === 3
        lifeWithoutDeathRule.selected = index === 4
        life34Rule.selected = index === 5
        diamoebaRule.selected = index === 6
        twoX2Rule.selected = index === 7
        highLifeRule.selected = index === 8
        dayNightRule.selected = index === 9
        morleyRule.selected = index === 10
        annealRule.selected = index === 11

        switch (index) {
        case 0: survivalRules = [2, 3]; growthRules = [3]; break
        case 1: survivalRules = [1, 3, 5, 7]; growthRules = [1, 3, 5, 7]; break
        case 2: survivalRules = []; growthRules = [2]; break
        case 3: survivalRules = [4]; growthRules = [2, 5]; break
        case 4: survivalRules = [0, 1, 2, 3, 4, 5, 6, 7, 8]; growthRules = [3]; break
        case 5: survivalRules = [3, 4]; growthRules = [3, 4]; break
        case 6: survivalRules = [5, 6, 7, 8]; growthRules = [3, 5, 6, 7, 8]; break
        case 7: survivalRules = [1, 2, 5]; growthRules = [3, 6]; break
        case 8: survivalRules = [2, 3]; growthRules = [3, 6]; break
        case 9: survivalRules = [3, 4, 6, 7, 8]; growthRules = [3, 6, 7, 8]; break
        case 10: survivalRules = [2, 4, 5]; growthRules = [3, 6, 8]; break
        case 11: survivalRules = [3, 5, 6, 7, 8]; growthRules = [4, 6, 7, 8]; break
        }
    }

    LinearGradient {
        id: mask
        height: 172
        width: 1032
        opacity: 0
        start: Qt.point(0, 0)
        end: Qt.point(1032, 0)

        gradient: Gradient {
            GradientStop { position: 0.025; color: Color.transparent }
            GradientStop { position: 0.1; color: Color.black }
            GradientStop { position: 0.9; color: Color.black }
            GradientStop { position: 0.975; color: Color.transparent }
        }
    }

    Item {
        id: flickabeFrame
        x: 30
        height: 172
        width: 1032
        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }

        Flickable {
            x: 112
            height: 172
            width: 808
            contentHeight: 172
            contentWidth: 2504

            RuleSetButton {
                id: lifeRule
                x: 0
                y: 0
                title: "Life"
                birthIndexes: "3"
                survivalIndexes: "23"
                selected: true
                onSwitchedOn: selectRule(0)
            }

            RuleSetButton {
                id: replicatorRule
                y: 0
                anchors.left: lifeRule.right
                anchors.leftMargin: 40
                title: "Replicator"
                birthIndexes: "1357"
                survivalIndexes: "1357"
                onSwitchedOn: selectRule(1)
            }

            RuleSetButton {
                id: seedsRule
                y: 0
                anchors.left: replicatorRule.right
                anchors.leftMargin: 40
                title: "Seeds"
                birthIndexes: "2"
                survivalIndexes: ""
                onSwitchedOn: selectRule(2)
            }

            RuleSetButton {
                id: namelessRule
                y: 0
                anchors.left: seedsRule.right
                anchors.leftMargin: 40
                title: "B25/S4"
                birthIndexes: "25"
                survivalIndexes: "4"
                onSwitchedOn: selectRule(3)
            }

            RuleSetButton {
                id: lifeWithoutDeathRule
                y: 0
                anchors.left: namelessRule.right
                anchors.leftMargin: 40
                title: "Life without Death"
                birthIndexes: "3"
                survivalIndexes: "012345678"
                onSwitchedOn: selectRule(4)
            }

            RuleSetButton {
                id: life34Rule
                y: 0
                anchors.left: lifeWithoutDeathRule.right
                anchors.leftMargin: 40
                title: "34 Life"
                birthIndexes: "34"
                survivalIndexes: "34"
                onSwitchedOn: selectRule(5)
            }

            RuleSetButton {
                id: diamoebaRule
                y: 0
                anchors.left: life34Rule.right
                anchors.leftMargin: 40
                title: "Diamoeba"
                birthIndexes: "35678"
                survivalIndexes: "5678"
                onSwitchedOn: selectRule(6)
            }

            RuleSetButton {
                id: twoX2Rule
                y: 0
                anchors.left: diamoebaRule.right
                anchors.leftMargin: 40
                title: "2x2"
                birthIndexes: "36"
                survivalIndexes: "125"
                onSwitchedOn: selectRule(7)
            }

            RuleSetButton {
                id: highLifeRule
                y: 0
                anchors.left: twoX2Rule.right
                anchors.leftMargin: 40
                title: "High Life"
                birthIndexes: "36"
                survivalIndexes: "23"
                onSwitchedOn: selectRule(8)
            }

            RuleSetButton {
                id: dayNightRule
                y: 0
                anchors.left: highLifeRule.right
                anchors.leftMargin: 40
                title: "Day & Night"
                birthIndexes: "3678"
                survivalIndexes: "34678"
                onSwitchedOn: selectRule(9)
            }

            RuleSetButton {
                id: morleyRule
                y: 0
                anchors.left: dayNightRule.right
                anchors.leftMargin: 40
                title: "Morley"
                birthIndexes: "368"
                survivalIndexes: "245"
                onSwitchedOn: selectRule(10)
            }

            RuleSetButton {
                id: annealRule
                y: 0
                anchors.left: morleyRule.right
                anchors.leftMargin: 40
                title: "Anneal"
                birthIndexes: "4678"
                survivalIndexes: "35678"
                onSwitchedOn: selectRule(11)
            }
        }
    }

    Button {
        id: leftIndicator
        height: 172
        width: 100
    }
}
