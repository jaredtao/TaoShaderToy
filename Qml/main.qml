import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "./Comp"
Window {
    visible: true
    width:  600
    height: 800
    title: qsTr("HelloShader")

    Loader {
        id: toyLoader
        width: parent.width
        height: parent.height - 40
        onLoaded: {
            toy.pixelShader = item.pixelShader
            if (item.iChannel0) {
                toy.iChannel0 = item.iChannel0
            }
            if (item.iChannel1) {
                toy.iChannel1 = item.iChannel1
            }
            if (item.iChannel2) {
                toy.iChannel2 = item.iChannel2
            }
            if (item.iChannel3) {
                toy.iChannel3 = item.iChannel3
            }
            toy.restart()
        }
    }
    TShaderToy {
        id: toy
        width: parent.width
        height: parent.height - 40
        running: false
    }
    FPSItem {
        id: fpsItem
        running: toy.running
    }
    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        spacing: 10
        ComboBox {
            model: ListModel{
                ListElement { name: "3I23Rh"; path: "qrc:/Qml/Shader/Shader_3I23Rh.qml"}
                ListElement { name: "4ddfwx"; path: "qrc:/Qml/Shader/Shader_4ddfWX.qml"}
                ListElement { name: "Id3Gz2"; path: "qrc:/Qml/Shader/Shader_Id3Gz2.qml"}
                ListElement { name: "XtlSD7"; path: "qrc:/Qml/Shader/Shader_XtlSD7.qml"}
            }
            textRole: "name"
            onCurrentTextChanged: {
                toyLoader.source = model.get(currentIndex).path
            }
        }
        ImageBtn {
            width: 32
            height: 32
            tipText: "Reset"
            imageUrl: "qrc:/Img/reset.png"
            onClicked: {
                toy.restart()
            }
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: parent.containsMouse ? 1 : 0
                border.color: "gray"
            }
        }
        ImageBtn {
            width: 32
            height: 32
            imageUrl: isPaused ?  "qrc:/Img/resume.png" : "qrc:/Img/pause.png"
            tipText: isPaused ? "Resume" : "Pause"
            property bool isPaused: false
            onClicked: {
                toy.running = isPaused
                isPaused = !isPaused;
            }
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: parent.containsMouse ? 1 : 0
                border.color: "gray"
            }
        }
        Text {
            text: toy.iTime.toFixed(2)
            color: "black"
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: fpsItem.fps + " fps"
            color: "black"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
