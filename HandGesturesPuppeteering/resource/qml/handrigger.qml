import QtQuick 2.5
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Item {
    id: item
    property var keys: []
    property var squareDist: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]  // square distance from mouse to key
    property var weights: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]     // weight return from Python
    property var center: Qt.point(rectbackground.width/2,rectbackground.height/2)
    property var radius: 135                                      // radius of background circle
    property var keyRadius: 6
    property var mousePos: Qt.point(0, 0)
    property var handRiggerState: 0                               // Disable = 0, Ready = 1, Preview = 2, Record = 3
    property var strReady: qsTr("Press hotkey [P] to start/stop preview.\nPress Space to start/stop recording.\nClick on the buttons,or press hotkey B to select the control modes.")
    
    property var backgroundColor: Qt.hsla(0.28, 0.9, 0.8, 0.25)   // Qt.hsla: hue, saturation, lightness, alpha
    // another way to set color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
    
    property var backgroundDisabledColor: Qt.hsla(0.28, 0.0, 0.8, 0.25)
    property var keyDisabledFillColor: Qt.hsla(0.055, 0.0, 0.6, 1.0)
    property var keyDisabledStrokeColor: Qt.hsla(0.055, 0.0, 0.4, 1.0)
    property var lineColor: Qt.hsla(0.0, 0.0,0.5, 0.9)


    property int gesturex:121
    property int gesturey:42
    property int gesturev:52
    property int gesturey2:37

    property int blendMode: 1

    width: 400
    height: 415
    enabled: true
    
    Rectangle {
        id: rect
        color: "#282828"
        anchors.fill: parent
        border.width: 0

        Label {
            id: label
            y: 0
            x:rectbackground.x
            width:rectbackground.width
            color: "#c8c8c8"
            text: strReady
            visible: true
            font.pointSize: 9
            font.family: "Arial"
            //verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            //anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: rectbackground
            x: 13
            y: 60
            color: "transparent"
            border.width: 1
            border.color:"#505050"
            Layout.fillWidth: true
            Layout.fillHeight:  true
            width: 374
            height: 312
            Image {
                height: parent.height-36
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "images/Circle_bg.png"
            }
            Canvas {
                id: canvas
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    // clear
                    ctx.reset()

               /*    // draw background circle
                   ctx.fillStyle = handRiggerState ? backgroundColor : backgroundDisabledColor
                   ctx.ellipse(center.x-radius, center.y-radius, 2*radius, 2*radius)
                   ctx.fill()

                   // draw 7 keys
                   ctx.lineWidth = 1
                   for (var i=0; i<keys.length; ++i) {
                       if(handRiggerState == 0) {  // Disable
                           ctx.strokeStyle = keyDisabledStrokeColor
                           ctx.fillStyle = keyDisabledFillColor
                       }
                       else {
                           var h = 0.20 - weights[i]*0.19
                           var s = 0.6  + weights[i]*0.35
                           var l = 0.35 + weights[i]*0.15
                           var a = 1.0
                           ctx.strokeStyle = Qt.hsla( h, s, l, a )
                           ctx.fillStyle = Qt.hsla( h, s, l, a )
                       }
                       ctx.beginPath()
                       ctx.ellipse(keys[i].x-keyRadius, keys[i].y-keyRadius, 2*keyRadius, 2*keyRadius)
                       ctx.fill()
                       ctx.stroke()
                   }
                   */
                    if (handRiggerState >= 2) {
                        // draw lines
                        ctx.strokeStyle = lineColor
                        for (var i=0; i<keys.length; ++i) {
                            if (weights[i] == 0.0) {
                                continue
                            }
                            ctx.beginPath()
                            ctx.moveTo(mousePos.x, mousePos.y)
                            ctx.lineTo(keys[i].x, keys[i].y)
                            ctx.stroke()
                        }
                    }
                }

                MouseArea {
                    id: ma
                    hoverEnabled: true
                    opacity: 0
                    anchors.fill: parent
                    cursorShape:(handRiggerState>=2)? Qt.BlankCursor:Qt.ArrowCursor
                    onPositionChanged:
                    {
                        if (handRiggerState >= 2) {
                            mousePos.x = mouse.x
                            mousePos.y = mouse.y

                            cursor.x = mouse.x-10
                            cursor.y = mouse.y-10

                            //label.text = "(" + mouse.x.toString() + ", " + mouse.y.toString() + ")"
                            for (var i=0; i<keys.length; ++i) {
                                var x_dist = keys[i].x - mouse.x
                                var y_dist = keys[i].y - mouse.y
                                squareDist[i] = x_dist * x_dist + y_dist * y_dist
                            }
                            weights = handRigger.process_data(squareDist)
                        }
                        canvas.requestPaint()
                    }
                }
            }

            Rectangle{
                id:hand00
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source:
                        (handRiggerState == 0) ? "images/hand00_dis.png" :
                        ( (weights[0] == 0) ? "images/hand00.png" : "images/hand00_hov.png" )
                }
            }
            Rectangle{
                id:hand01
                x: parent.width-gesturev
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: (handRiggerState == 0) ? "images/hand01_dis.png" :
                        ( (weights[1] == 0) ? "images/hand01.png" : "images/hand01_hov.png" )
                }
            }




            Rectangle{
                id:hand02
                x:parent.width-hand03.x
                y:hand03.y
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: (handRiggerState == 0) ? "images/hand02_dis.png" :
                        ( (weights[2] == 0) ? "images/hand02.png" : "images/hand02_hov.png" )
                }
            }

            Rectangle{
                id:hand03
                x:hand05.x
                y:parent.height-gesturey2
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source:  (handRiggerState == 0) ? "images/hand03_dis.png" :
                        ( (weights[3] == 0) ? "images/hand03.png" : "images/hand03_hov.png" )
                }
            }

            Rectangle{
                id:hand04
                x:parent.width-hand01.x
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: (handRiggerState == 0) ? "images/hand04_dis.png" :
                        ( (weights[4] == 0) ? "images/hand04.png" : "images/hand04_hov.png" )
                }
            }

            Rectangle{
                id:hand05
                x:gesturex
                y:gesturey
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: (handRiggerState == 0) ? "images/hand05_dis.png" :
                        ( (weights[5] == 0) ? "images/hand05.png" : "images/hand05_hov.png" )
                }
            }


            Rectangle{
                id:hand06
                x: parent.width-hand05.x
                y: hand05.y

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: (handRiggerState == 0) ? "images/hand06_dis.png" :
                        ( (weights[6] == 0) ? "images/hand06.png" : "images/hand06_hov.png" )
                }
            }

            Rectangle{
                id:cursor
                Image {
                    source: (handRiggerState == 0) ? "images/dot_dis.png" : "images/dot_Default.png"
                }
            }
        }

        RowLayout{
            x: 13
            y: 382
            width: rectbackground.width
            height: 25
            spacing:15
            RLButton{
                id:twosideModeButton
                implicitWidth:(parent.width-15)/2
                text:qsTr("2-Point Blend")
                checked:true
                onClicked:{
                    multisideModeButton.checked=false
                    twosideModeButton.checked=true
                    blendMode = 1
                    handRigger.set_blend_mode(blendMode)
                }
            }
            RLButton{
                id:multisideModeButton
                Layout.fillWidth: true
                text:qsTr("Multi-Point Blend")
                checked:false
                onClicked:{
                    twosideModeButton.checked=false
                    multisideModeButton.checked=true
                    blendMode = 0
                    handRigger.set_blend_mode(blendMode)
                }
            }
        }
    }

    Component.onCompleted: {
        keys.push(center)
        for ( var i=0; i<6; ++i ) {
            var key = Qt.point(0,0)
            key.x = center.x + radius * Math.cos( ( i*60) * Math.PI / 180)
            key.y = center.y + radius * Math.sin( ( i*60) * Math.PI / 180)
            keys.push(key)
        }
    }

    function updateHandRiggerState( state )
    {
        handRiggerState = state
        switch (handRiggerState) {
            case 0:
                for ( var i=0; i<7; ++i) {
                    weights[i] = 0.0
                }
                break
            case 1:
                label.text = strReady
                label.horizontalAlignment = Text.AlignLeft

                for ( var i=0; i<7; ++i) {
                    weights[i] = 0.0
                }
                break
            case 2:
            case 3:
                break
        }
        item.enabled = state > 0
        canvas.requestPaint()
    }

    function setBlendMode( mode )
    {
        // labelBlendMode.text = strBlendMode[mode]
        blendMode = mode
        twosideModeButton.checked = (blendMode == 1)
        multisideModeButton.checked = (blendMode == 0)
    }

}

