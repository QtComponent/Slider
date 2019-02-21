import QtQuick 2.5
import "../" as My

Rectangle {
    width: 640; height: 480

    Column {
        anchors.centerIn: parent

        /* Default Slider */
        My.Slider {
            id: slider
        }

        /* Slider with a red background  */
        My.Slider {
            id: slider2

            background: Rectangle {
                width: slider2.width
                height: 5
                radius: 2
                color: "#bdbebf"

                /* available rectangle */
                Rectangle {
                    width:  slider2.value/slider2.to*parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "red"
                }
            }
        }

        /* handle is rectangle */
        My.Slider {
            id: slider3

            handle: Rectangle {
                width: 13
                height: 20
                color: slider3.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }

            background: Rectangle {
                width: slider.width
                height: 5
                radius: 2
                color: "#bdbebf"

                /* available rectangle */
                Rectangle {
                    width:  slider3.value/slider.to*parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "blue"
                }
            }
        }

        /* handle is rectangle */
        My.Slider {
            id: slider4

            handle: Rectangle {
                width: 20
                height: width
                radius: width/2
                color: slider4.pressed ? "red" : "#f6f6f6"
                border.color: "#bdbebf"

                Text {
                    anchors.centerIn: parent
                    text: parseInt(slider4.value)
                    visible: slider4.pressed
                    color: slider4.pressed ? "white" : "black"
                }
            }

            background: Rectangle {
                width: slider.width
                height: 5
                radius: 2
                color: "lightgreen"

                /* available rectangle */
                Rectangle {
                    width:  slider4.value/slider.to*parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "lightblue"
                }
            }
        }
    }
}
