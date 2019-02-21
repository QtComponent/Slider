import QtQuick 2.5
import "../" as My

Rectangle {
    width: 180; height: 30
    My.Slider {
        anchors.centerIn: parent

        stepSize: 1.0
        onValueChanged: {
            console.log("Value: ", value)
        }

        handle: Rectangle {
            width: 10
            height: width
            radius: width / 2
            color: parent.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }
    }

//    My.Slider {
//        x: 50
//        anchors.verticalCenter: parent.verticalCenter
//        orientation: Qt.Vertical
//        stepSize: 1.0
//        onPositionChanged: console.log(position)
//        onValueChanged: {
//            console.log("Value: ", value)
//        }
//    }
}
