import QtQuick 2.0
import "../" as My

Rectangle {
    width: 320; height: 240

    Row {
        anchors.centerIn: parent
        spacing: 20

        Column {
            spacing: 10
            /* Default Slider */
            My.Slider {
                id: slider
                focus: true
                Keys.onDownPressed: slider.decrease()
                Keys.onUpPressed: slider.increase()
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
                        width:  slider2.position*parent.width
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
                        width:  slider3.position*parent.width
                        height: parent.height
                        radius: parent.radius
                        color: "blue"
                    }
                }
            }

            /* handle is rectangle */
            My.Slider {
                id: slider4
                to: 100

                handle: Rectangle {
                    width: 20
                    height: width
                    radius: width/2
                    color: slider4.pressed ? "red" : "#f6f6f6"
                    border.color: "#bdbebf"

                    Text {
                        anchors.centerIn: parent
                        text: parseInt(slider4.position*slider4.to)
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
                        width:  slider4.position*parent.width
                        height: parent.height
                        radius: parent.radius
                        color: "lightblue"
                    }
                }
            }
        }

        My.Slider {
            id: slider5
            orientation: Qt.Vertical
            stepSize: 0.2
            handle: Rectangle {
                width: 13
                height: 20
                color: slider3.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }

            background: Rectangle {
                width: 10
                height: slider5.height
                radius: 2
                color: "#bdbebf"

                /* available rectangle */
                Rectangle {
                    height: slider5.position*parent.height
                    width: parent.width
                    radius: parent.radius
                    color: "blue"
                }
            }
        }
    }
}
