import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
Window {
    visible: true
    width:  600
    height: 800
    title: qsTr("HelloShader")
    TShaderToy {
        id: toy
        width: parent.width
        height: parent.height - 40
        pixelShader: "
// Smooth HSV to RGB conversion
vec3 hsv2rgb_smooth( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    rgb = rgb*rgb*(3.0-2.0*rgb); // cubic smoothing

    return c.z * mix( vec3(1.0), rgb, c.y);
}

// compare
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    vec3 hsl = vec3( uv.x, 1.0, uv.y );

    vec3 rgb = hsv2rgb_smooth( hsl );

    fragColor = vec4( rgb, 1.0 );
}
"
    }
    FPSItem {
        id: fpsItem
        running: toy.running
    }
    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        spacing: 10
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
