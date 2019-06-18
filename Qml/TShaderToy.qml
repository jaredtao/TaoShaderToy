﻿import QtQuick 2.12
import QtQuick.Controls 2.12
/*
vec3        iResolution             image/buffer        The viewport resolution (z is pixel aspect ratio, usually 1.0)
float       iTime                   image/sound/buffer	Current time in seconds
float       iTimeDelta              image/buffer        Time it takes to render a frame, in seconds
int         iFrame                  image/buffer        Current frame
float       iFrameRate              image/buffer        Number of frames rendered per second
float       iChannelTime[4]         image/buffer        Time for channel (if video or sound), in seconds
vec3        iChannelResolution[4]	image/buffer/sound	Input texture resolution for each channel
vec4        iMouse                  image/buffer        xy = current pixel coords (if LMB is down). zw = click pixel
sampler2D	iChannel{i}             image/buffer/sound	Sampler for input textures i
vec4        iDate                   image/buffer/sound	Year, month, day, time in seconds in .xyzw
float       iSampleRate             image/buffer/sound	The sound sample rate (typically 44100)
*/
ShaderEffect {
    id: shader

    //properties for shader

    //not pass to shader
    readonly property vector3d defaultResolution: Qt.vector3d(shader.width, shader.height, shader.width / shader.height)
    function calcResolution(channel) {
        if (channel) {
            return Qt.vector3d(channel.width, channel.height, channel.width / channel.height);
        } else {
            return defaultResolution;
        }
    }
    //pass
    readonly property vector3d  iResolution: defaultResolution
    property real       iTime: 0
    property real       iTimeDelta: 100
    property int        iFrame: 10
    property real       iFrameRate
    property vector4d   iMouse;
    property var iChannel0; //only Image or ShaderEffectSource
    property var iChannel1; //only Image or ShaderEffectSource
    property var iChannel2; //only Image or ShaderEffectSource
    property var iChannel3; //only Image or ShaderEffectSource
    property var        iChannelTime: [0, 1, 2, 3]
    property var        iChannelResolution: [calcResolution(iChannel0), calcResolution(iChannel1), calcResolution(iChannel2), calcResolution(iChannel3)]
    property vector4d   iDate;
    property real       iSampleRate: 44100

    //properties for Qml controller
    property alias hoverEnabled: mouse.hoverEnabled
    property bool running: true

    function restart() {
        timeAnimation.restart()
    }
    NumberAnimation {
        id: timeAnimation
        target: shader
        property: "iTime"
        from: 0
        to: Math.PI * 2
        duration: 6914
        running: shader.running
        loops: Animation.Infinite;
    }
    Timer {
        id: timer
        running: true
        interval: 1000
        onTriggered: {
            var date = new Date();
            shader.iDate.x = date.getFullYear();
            shader.iDate.y = date.getMonth();
            shader.iDate.z = date.getDay();
            shader.iDate.w = date.getSeconds()
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        onPositionChanged: {
            shader.iMouse.x = mouseX
            shader.iMouse.y = mouseY
        }
        onClicked: {
            shader.iMouse.z = mouseX
            shader.iMouse.w = mouseY
        }
    }
    readonly property string forwardString: "
        #ifdef GL_ES
            precision mediump float;
        #else
        #   define lowp
        #   define mediump
        #   define highp
        #endif // GL_ES

        in vec2 qt_TexCoord0;
        uniform lowp   float qt_Opacity;

        uniform vec3   iResolution;
        uniform float  iTime;
        uniform float  iTimeDelta;
        uniform int    iFrame;
        uniform float  iFrameRate;
        uniform float  iChannelTime[4];
        uniform vec3   iChannelResolution[4];
        uniform vec4   iMouse;
        uniform vec4    iDate;
        uniform float   iSampleRate;
        uniform sampler2D   iChannel0;
        uniform sampler2D   iChannel1;
        uniform sampler2D   iChannel2;
        uniform sampler2D   iChannel3;
    "
    readonly property string startCode: "
        void main(void)
        {
            mainImage(gl_FragColor, gl_FragCoord.xy);
        }"
    readonly property string defaultPixelShader: "
        void mainImage(out vec4 fragColor, in vec2 fragCoord)
        {
            fragColor = vec4(fragCoord, fragCoord.x, fragCoord.y);
        }"
    property string pixelShader: ""
    fragmentShader: forwardString + (pixelShader ? pixelShader : defaultPixelShader) + startCode
}
