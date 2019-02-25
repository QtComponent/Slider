import QtQuick 2.0
import "../" as My

Rectangle {
    width: 320; height: 240

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: 30
        width: 14
        height: width
        radius: width/2
        color: mouseArea.position === 0 ? "#d5d5d5" : "#f52e06"

        NumberAnimation on width { running: mouseArea.pressed; from: 14; to: 20; duration: 100 }
        NumberAnimation on width { running: !mouseArea.pressed; from: 20; to: 14; duration: 100 }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: parent
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: 20

        Column {
            spacing: 10
            /* handle is rectangle */
            My.Slider {
                id: slider
                to: 100

                handle: Item {
                        width: 14
                        height: width

                    Rectangle {
                        width: 14
                        height: width
                        radius: width/2
                        color: slider.position === 0 ? "#d5d5d5" : "#f52e06"
                        anchors.verticalCenter: parent.verticalCenter

                        NumberAnimation on width { running: slider.pressed; from: 14; to: 20; duration: 100 }
                        NumberAnimation on width { running: !slider.pressed; from: 20; to: 14; duration: 100 }

                        Rectangle {
                            anchors.centerIn: parent
                            width: 10; height: width
                            radius: width/2
                            visible: slider.position === 0
                            color: "white"

                            NumberAnimation on width { running: slider.pressed; from: 10; to: 14; duration: 100 }
                            NumberAnimation on width { running: !slider.pressed; from: 14; to: 10; duration: 100 }
                        }
                    }
                }

                background: Rectangle {
                    width: 200
                    height: 2
                    radius: 2
                    color: "#d5d5d5"

                    /* available rectangle */
                    Rectangle {
                        width:  slider.position*parent.width
                        height: parent.height
                        radius: parent.radius
                        color: "#f52e06"
                    }
                }
            }
        }
    }
}
