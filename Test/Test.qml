import QtQuick 2.5
import "../" as My

Rectangle {
    width: 180; height: 30

    My.Slider {
        id: slider
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

        background: Rectangle {
            width: slider.width
            height: 5
            radius: 2
            color: "#bdbebf"

            /* available rectangle */
            Rectangle {
                width:  slider.value/slider.to*parent.width
                height: parent.height
                radius: parent.radius
                color: "#21be2b"
            }
        }
    }
}
