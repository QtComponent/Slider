import QtQuick 2.5
import "../"

Rectangle {
    Slider {
        anchors.centerIn: parent

        stepSize: 1.0
        onValueChanged: {
            console.log("Value: ", value)
        }
    }

    Slider {
        x: 50
        anchors.verticalCenter: parent.verticalCenter
        orientation: Qt.Vertical
        stepSize: 1.0
        onValueChanged: {
            console.log("Value: ", value)
        }
    }
}
