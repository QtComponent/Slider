import QtQuick 2.5
import QtQuick.Controls 1.4

Slider {
    maximumValue: 5.0
    stepSize: 1.0
    onValueChanged: {
        console.log("Value: ", value)
    }

    onStepSizeChanged: {
        console.log("SetpSize: ", stepSize)
    }
}
