import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import PythonBackendLibrary 1.0

ApplicationWindow {
    title: qsTr('QtQuick2 + rospy')
    id: root
    width: 450
    height: 400
    visible: true

    Material.theme: Material.Light
    Material.accent: Material.Indigo

    Button {
        id: publishButton
        x: 100
        y: 84
        text: qsTr("Publish")
        z: 4
        enabled: true
        anchors.rightMargin: 25
        anchors.right: parent.right
        highlighted: false

        onClicked: {
            backend.publish_string(publishTopicName.text, valueToPublish.text)
        }
    }

    TextField {
        id: publishTopicName
        y: 25
        height: 40
        text: qsTr("/chatter")
        z: 6
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 25
        selectByMouse: true
    }

    TextField {
        id: valueToPublish
        y: 84
        text: qsTr("Hello, World!")
        z: 5
        anchors.rightMargin: 148
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 25
        selectByMouse: true
    }

    Text {
        id: sliderTopicName
        y: 145
        height: 34
        text: qsTr("Publish data to /slider topic")
        z: 3
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.letterSpacing: 0
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 24
    }

    Slider {
        id: slider
        y: 192
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 25
        value: 0.5

        onValueChanged: {
            backend.publish_slider(slider.value)
        }
    }

    PythonBackend {
        id: backend

        onMsg_received: {
            receivedData.text = received_data
        }
    }

    Text {
        id: subscribedTopicName
        y: 253
        height: 34
        text: qsTr("Data received on chatter topic")
        z: 3
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.letterSpacing: 0
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 24
    }

    Text {
        id: receivedData
        y: 301
        height: 85
        text: qsTr("Received data will appear here...")
        z: 2
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 25
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pointSize: 12
        enabled: false
    }
}
