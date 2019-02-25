import QtQuick 2.0

Item {
    id: root
    width: _private.defaultWidth
    height: _private.defaultHeight
    rotation: orientation === Qt.Vertical ? 180 : 0

    /* public */
    // This property holds the starting value for the range. The default value is 0.0.
    property real from: 0.0

    // This property holds the end value for the range. The default value is 1.0.
    property real to: 1.0

    // This property holds the value in the range from - to. The default value is 0.0.
    // Unlike the position property, the value is not updated while the handle is dragged. The value is updated after the value has been chosen and the slider has been released.
    property real value: 0.0

    // This property holds the step size. The default value is 0.0.
    property real stepSize: 0

    // This property holds the orientation.
    // note: [Qt.Horizontal(default) | Qt.Vertical]
    property int orientation: Qt.Horizontal

    // This property holds the logical position of the handle.
    // The position is defined as a percentage of the control's size, scaled to 0.0 - 1.0.
    // Unlike the value property, the position is continuously updated while the handle is dragged.
    // For visualizing a slider, the right-to-left aware visualPosition should be used instead.
    property real position: 0.0 // note: [read-only]

    // This property holds whether the slider is pressed.
    property bool pressed: false

    // This property holds the handle item.
    property Component handle: _private.defaultHandle

    // This property holds the background item.
    property Component background: _private.defaultBackground

    // Decreases the value by stepSize or 0.1 if stepSize is not defined.
    function decrease() {
        var _stepSize = stepSize === 0 ? 0.1 : stepSize
        position -= _stepSize
    }

    // Increases the value by stepSize or 0.1 if stepSize is not defined.
    function increase() {
        var _stepSize = stepSize === 0 ? 0.1 : stepSize
        position += _stepSize
    }

    /* private */
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
        width: parent.width
        height: parent.height
        onPressed: root.pressed = true
        onReleased: {
            root.pressed = false
            root.value = root.position*to
        }
        onPositionChanged: {
            root.position = _private.adjustPosition(mouseArea)
        }
        onClicked: {
            root.position = _private.adjustPosition(mouseArea)
        }
    }

    onValueChanged: {
        if (value > to)
            value = to

        if (value < from)
            value = from

        position = value/to
    }

    onPositionChanged: {
        if (position < 0)
            position = 0

        if (position > 1)
            position = 1

        _private.setHandlePosition()
    }

    Component.onCompleted: _private.setHandlePosition()

    QtObject {
        id: _private
        property real availableWidth: 0
        property real pathRadius: orientation === Qt.Vertical ? root.width * 2 / 15 : root.height * 2 / 15
        property real handleRadius: orientation === Qt.Vertical ? root.width * 3 / 5 : root.height * 3 / 5
        property real pathScale: 1
        property real defaultWidth:  orientation === Qt.Horizontal ? backgroundId.item.width : 30
        property real defaultHeight: orientation === Qt.Vertical ? backgroundId.item.height : 30

        property Component defaultHandle: Rectangle {
            width: _private.handleRadius
            height: width
            radius: width / 2
            color: root.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }

        property Component defaultBackground: Rectangle {
            width:  orientation === Qt.Horizontal ? 150  : _private.pathRadius
            height: orientation === Qt.Vertical   ? 30 : _private.pathRadius
            radius: 2
            color: "#bdbebf"

            /* available rectangle */
            Rectangle {
                width: orientation === Qt.Horizontal ? position*parent.width : parent.width
                height: orientation === Qt.Vertical ? position*parent.height : parent.height
                radius: parent.radius
                color: "#21be2b"
            }
        }

        function adjustPosition(mouseArea) {
            var _backgroundIdValue = 0
            var _mouseValue = 0
            var _rootValue = 0

            if (orientation === Qt.Vertical) {
                _backgroundIdValue = backgroundId.item.height
                _mouseValue = mouseArea.mouseY
            }
            else {
                _backgroundIdValue = backgroundId.item.width
                _mouseValue = mouseArea.mouseX
            }

            var _position = (_mouseValue / _backgroundIdValue)

            if (stepSize === 0)
                return _position

            if (_position > (position + stepSize))
                return position + stepSize

            if (_position < (position - stepSize))
                return position - stepSize

            return position
        }

        function getX(position) {
            if (orientation === Qt.Horizontal) {
                if (((backgroundId.item.width*position) - handleId.width/2) <= 0) {
                    return 0
                }
                else if (((backgroundId.item.width*position) + handleId.width/2) >= backgroundId.item.width) {
                    return backgroundId.item.width - handleId.width
                }
                else {
                    return ((backgroundId.item.width*position) - handleId.width/2)
                }
            }
            else {
                return (root.width - handleId.width)/2
            }
        }

        function getY(position) {
            if (orientation === Qt.Vertical) {
                if (((backgroundId.item.height*position) - handleId.height/2) <= 0) {
                    return 0
                }
                else if (((backgroundId.item.height*position) + handleId.height/2) >= backgroundId.item.height) {
                    return backgroundId.item.height - handleId.height
                }
                else {
                    return ((backgroundId.item.height*position) - handleId.height/2)
                }
            }
            else {
                return (root.height - handleId.height)/2
            }
        }

        function setHandlePosition() {
            handleId.x = _private.getX(position)
            handleId.y =  _private.getY(position)
        }
    }
}
