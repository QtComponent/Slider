import QtQuick 2.0

Item {
    id: root
    width: _private.defaultWidth
    height: _private.defaultHeight

    /* public */
    property real value
    property real to: 100
    property real from: 0
    property int  orientation: Qt.Horizontal // [Qt.Horizontal | Qt.Vertical]
    property real stepSize: 1
    /** [read-only] position
     * This property holds the logical position of the handle.
     * The position is defined as a percentage of the control's size, scaled from 0.0 - 1.0.
     * Unlike the value property, the position is continuously updated while the handle is dragged.
     * For visualizing a slider, the right-from-left aware visualPosition should be used instead.
     */
    property real position: 0.0

    onValueChanged: console.log("Value: ", value)
    onPositionChanged: console.log("Position: ", position)

    /* path */
    Rectangle {
        id: path
        anchors.centerIn: parent
        implicitWidth:  orientation === Qt.Vertical ? _private.pathRadius : root.width * 0.85
        implicitHeight: orientation === Qt.Vertical ? root.height * 0.85 : _private.pathRadius
        radius: 2
        color: "#bdbebf"

        /* handle */
        Rectangle {
            id: handle
            x: orientation === Qt.Vertical ? (parent.width - width) / 2 : parent.width*value/to
            y: orientation === Qt.Vertical ? parent.height*value/to : (parent.height - height) / 2
            implicitWidth: orientation === Qt.Vertical ? root.width * 3 / 5 : root.height * 3 / 5
            implicitHeight: width
            radius: width / 2
            color: mouseArea.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }

        /* available rectangle */
        Rectangle {
            width: orientation === Qt.Horizontal ? handle.x : parent.implicitWidth
            height: orientation === Qt.Vertical ? handle.y : parent.implicitHeight
            radius: parent.radius
            color: "#21be2b"
        }
    }

    MouseArea {
        id: mouseArea
        property bool pressed: false
        anchors.fill: parent
        onPressed: pressed = true
        onReleased: {
            pressed = false
            root.position = _private.adjustPosition(mouseArea)
        }
        onPositionChanged: {
            if (pressed) {
                value = _private.adjustValue(mouseArea)
            }
        }
        onClicked: {
            value = _private.adjustValue(mouseArea)
        }
    }

    QtObject {
        id: _private
        property real availableWidth: 0
        property real pathRadius: orientation === Qt.Vertical ? root.width * 2 / 15 : root.height * 2 / 15
        property real defaultWidth: orientation === Qt.Vertical ? 30 : 180
        property real defaultHeight: orientation === Qt.Vertical ? 180 : 30

        function adjustPosition(mouseArea) {
            var _path = 0
            var _mouseValue = 0
            if (orientation === Qt.Vertical) {
                _path = path.height
                _mouseValue = mouseArea.mouseY
            }
            else {
                _path = path.width
                _mouseValue = mouseArea.mouseX
            }

            var _value = to * _mouseValue / _path
            if (_value >= to) {
                return 1.0
            }
            else if (_value <= from) {
                return 0.0
            }
            else {
                if (_value % stepSize >= (stepSize / 2))
                    return (Math.floor(_value / stepSize) + 1) * stepSize/to
                else
                    return Math.floor(_value / stepSize) * stepSize/to
            }
        }

        function adjustValue(mouseArea) {
            return adjustPosition(mouseArea)*to
        }
    }
}
