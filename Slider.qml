import QtQuick 2.0

Item {
    id: root
    width: _private.defaultWidth
    height: _private.defaultHeight
    rotation: orientation === Qt.Vertical ? 180 : 0

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

    /* path */
    Rectangle {
        id: path
        anchors.centerIn: parent
        implicitWidth:  orientation === Qt.Vertical ? _private.pathRadius : root.width * _private.pathScale
        implicitHeight: orientation === Qt.Vertical ? root.height * _private.pathScale : _private.pathRadius
        radius: 2
        color: "#bdbebf"

        /* handle */
        Rectangle {
            id: handle
            x: orientation === Qt.Vertical ? (parent.width - implicitWidth)/2 : (parent.width*value/to) - implicitWidth/2
            y: orientation === Qt.Vertical ? (parent.height*value/to) - implicitWidth/2 : (parent.height - implicitHeight)/2
            implicitWidth: _private.handleRadius
            implicitHeight: implicitWidth
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
        property real handleRadius: orientation === Qt.Vertical ? root.width * 3 / 5 : root.height * 3 / 5
        property real pathScale: 0.85
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

            var _value = (to * (_mouseValue - (_rootValue - _path)/2) / _path)

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
