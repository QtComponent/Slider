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
    property real position: 0.0 // note: [read-only]
    property bool pressed: false

    property Component handle: _private.defaultHandle
    property Component background: _private.defaultBackground

    /* background */
    Loader {
        id: backgroundId
        anchors.centerIn: parent
        sourceComponent: root.background
    }

    /* handle */
    Loader {
        id: handleId
        sourceComponent: root.handle
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: root.pressed = true
        onReleased: {
            root.pressed = false
            root.position = _private.adjustPosition(mouseArea)
        }
        onPositionChanged: {
            if (root.pressed) {
                value = _private.adjustValue(mouseArea)
            }
        }
        onClicked: {
            value = _private.adjustValue(mouseArea)
        }
    }

    onValueChanged: {
        if (! root.pressed)
            position = value/to

        if (value > to)
            value = to

        if (value < from)
            value = from

        _private.setHandlePosition(value)
    }

    Component.onCompleted: _private.setHandlePosition(value)

    QtObject {
        id: _private
        property real availableWidth: 0
        property real pathRadius: orientation === Qt.Vertical ? root.width * 2 / 15 : root.height * 2 / 15
        property real handleRadius: orientation === Qt.Vertical ? root.width * 3 / 5 : root.height * 3 / 5
        property real pathScale: 1
        property real defaultWidth:  orientation === Qt.Horizontal ? 150 : 30
        property real defaultHeight: orientation === Qt.Vertical ? 150 : 30

        property Component defaultHandle: Rectangle {
            width: _private.handleRadius
            height: width
            radius: width / 2
            color: root.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }

        property Component defaultBackground: Rectangle {
            width:  orientation === Qt.Horizontal ? root.width  : _private.pathRadius
            height: orientation === Qt.Vertical   ? root.height : _private.pathRadius
            radius: 2
            color: "#bdbebf"

            /* available rectangle */
            Rectangle {
                width: orientation === Qt.Horizontal ? value/to*parent.width : parent.width
                height: orientation === Qt.Vertical ? value/to*parent.height : parent.height
                radius: parent.radius
                color: "#21be2b"
            }
        }

        function adjustPosition(mouseArea) {
            var _backgroundId = 0
            var _mouseValue = 0
            var _rootValue = 0

            if (orientation === Qt.Vertical) {
                _backgroundId = backgroundId.height
                _mouseValue = mouseArea.mouseY
                _rootValue = root.height
            }
            else {
                _backgroundId = backgroundId.width
                _mouseValue = mouseArea.mouseX
                _rootValue = root.width
            }

            var _value = (to * _mouseValue / _backgroundId)

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

        function getX(value) {
            if (orientation === Qt.Horizontal) {
                if (((backgroundId.width*value/to) - handleId.width/2) <= 0) {
                    return 0
                }
                else if (((backgroundId.width*value/to) + handleId.width/2) >= backgroundId.width) {
                    return backgroundId.width - handleId.width
                }
                else {
                    return ((backgroundId.width*value/to) - handleId.width/2)
                }
            }
            else {
                return (root.width - handleId.width)/2
            }
        }

        function getY(value) {
            if (orientation === Qt.Vertical) {
                if (((backgroundId.height*value/to) - handleId.height/2) <= 0) {
                    return 0
                }
                else if (((backgroundId.height*value/to) + handleId.height/2) >= backgroundId.height) {
                    return backgroundId.height - handleId.height
                }
                else {
                    return ((backgroundId.height*value/to) - handleId.height/2)
                }
            }
            else {
                return (root.height - handleId.height)/2
            }
        }

        function setHandlePosition(value) {
            handleId.x = _private.getX(value)
            handleId.y =  _private.getY(value)
        }
    }
}
