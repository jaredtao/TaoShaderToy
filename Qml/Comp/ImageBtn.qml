﻿import QtQuick 2.12
import QtQuick.Controls 2.12
Item {
    id: root
    property url normalUrl      //常规状态下的图片路径
    property url hoveredUrl     //悬浮
    property url pressedUrl     //按下
    property url disabledUrl    //禁用

    property alias imageItem: img           //直接别名导出Image实例，外面可以修改其任意属性
    property alias imageUrl: img.source     //别名导出图片路径

    property alias imageWidth: img.width
    property alias imageHeight: img.height
    property alias imageAnchors: img.anchors
    property alias containsMouse: area.containsMouse
    property alias containsPress: area.containsPress
    property alias tipText: t.text
    property int tipTimeout: t.timeout
    property int tipDelay: t.delay
    //点击信号
    signal clicked();
    Image {
        id: img
        anchors.fill: parent
        //默认按鼠标状态选取不同的图片
        source: root.enabled ? (containsPress ? pressedUrl : (containsMouse ? hoveredUrl : normalUrl)) : disabledUrl
    }
    ToolTip {
        id: t
        x: area.mouseX
        y: area.mouseY - 40
        visible: text && area.containsMouse
        delay: 300
    }
    MouseArea {
        id: area
        anchors.fill: parent;
        hoverEnabled: parent.enabled;
        onClicked: root.clicked();
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }
}

