import QtQuick 2.0

Item {
    id: root
    width: _private.defaultWidth
    height: _private.defaultHeight
    rotation: orientation === Qt.Vertical ? 180 : 0

    /* public */
    property real to: 100
    property real from: 0
    property real value
    property real stepSize: 0.1
    property int  orientation: Qt.Horizontal // [Qt.Horizontal | Qt.Vertical]
    /** [read-only] position
     * This property holds the logical position of the handle.
     * The position is defined as a percentage of the control's size, scaled from 0.0 - 1.0.
     * Unlike the value property, the position is continuously updated while the handle is dragged.
     * For visualizing a slider, the right-from-left aware visualPosition should be used instead.
     */
    property real position: 0.0

    /* path */
    Rectangle {
        id: path
        anchors.centerIn: parent
        width:  orientation === Qt.Vertical ? _private.pathRadius : root.width * _private.pathScale
        height: orientation === Qt.Vertical ? root.height * _private.pathScale : _private.pathRadius
        radius: 2
        color: "#bdbebf"

        /* handle */
        Rectangle {
            id: handle
            x: getX(value)
            y: getY(value)

            function getX(value) {
                if (orientation === Qt.Horizontal) {
                    if (((parent.width*value/to) - width/2) <= 0) {
                        return 0
                    }
                    else if (((parent.width*value/to) + width/2) >= parent.width) {
                        return parent.width - width
                    }
                    else {
                        return ((parent.width*value/to) - width/2)
                    }
                }
                else {
                    return (parent.width - width)/2
                }
            }

            function getY(value) {
                if (orientation === Qt.Vertical) {
                    if (((parent.height*value/to) - height/2) <= 0) {
                        return 0
                    }
                    else if (((parent.height*value/to) + height/2) >= parent.height) {
                        return parent.height - height
                    }
                    else {
                        return ((parent.height*value/to) - height/2)
                    }
                }
                else {
                    return (parent.height - height)/2
                }
            }
            width: _private.handleRadius
            height: width
            radius: width / 2
            color: mouseArea.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }

        /* available rectangle */
        Rectangle {
            width: orientation === Qt.Horizontal ? handle.x : parent.width
            height: orientation === Qt.Vertical ? handle.y : parent.height
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
        property real handleRadius: orientation === Qt.Vertical ? root.width * 3 / 5 : root.height * 3 / 5
        property real pathScale: 1
        property real defaultWidth: orientation === Qt.Vertical ? 50 : 280
        property real defaultHeight: orientation === Qt.Vertical ? 280 : 50

        function adjustPosition(mouseArea) {
            var _path = 0
            var _mouseValue = 0
            var _rootValue = 0

            if (orientation === Qt.Vertical) {
                _path = path.height
                _mouseValue = mouseArea.mouseY
                _rootValue = root.height
            }
            else {
                _path = path.width
                _mouseValue = mouseArea.mouseX
                _rootValue = root.width
            }

            var _value = (to * _mouseValue / _path)

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
