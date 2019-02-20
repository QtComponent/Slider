import QtQuick 2.5
import QtQuick.Controls 1.4
import "../" as My

Rectangle {
    My.Slider {
        anchors.centerIn: parent

        stepSize: 1.0
        onValueChanged: {
            console.log("Value: ", value)
        }
    }

    My.Slider {
        x: 50
        anchors.verticalCenter: parent.verticalCenter
        orientation: Qt.Vertical
        stepSize: 1.0
        onPositionChanged: console.log(position)
        onValueChanged: {
            console.log("Value: ", value)
        }
    }

    Slider {
         value: 0.5
         onValueChanged: console.log(value)
     }
}
