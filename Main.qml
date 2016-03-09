import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.DownloadManager 0.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "downloadmanager.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(60)
    height: units.gu(85)

    Page {
        title: i18n.tr("Download Manager")

        ListModel {
            id: mymodel
        }

        DownloadManager {
            id: manager

            onDownloadsChanged: {
                console.log("something is changed!");
                var length = downloads.length;

                console.log("length: " + length);

                for (var i = 0; i < length; i ++ ) {
                    downloads[i].finished.connect(onFinished);
                }

                function onFinished(path) {
                    console.log("path: " + path);
                    mymodel.append( {"filename" : path })
                }
            }
        }

        TextField {
            id: text
            placeholderText: "File URL to download..."
            height: units.gu(5)
            anchors {
                left: parent.left
                right: button.left
                rightMargin: units.gu(2)
            }

            text: "http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"
        }

        Button {
            id: button
            text: "Download"
            height: 50
            anchors.top: text.top
            anchors.bottom: text.bottom
            anchors.right: parent.right
            anchors.verticalCenter: text.verticalCenter
            onClicked: {
                manager.download(text.text);
            }
        }

        ListView {
            id: list
            clip: true
            anchors {
                left: parent.left
                right: parent.right
                top: text.bottom
            }
            height: units.gu(20)
            model: manager.downloads
            delegate: ProgressBar {
                width: parent.width

                minimumValue: 0
                maximumValue: 100
                value: modelData.progress
            }
        }

        GridView {
            id: pics
            clip: true
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: list.bottom

            model: mymodel
            cellWidth: pics.width/4; cellHeight: cellWidth + units.gu(2)
            delegate: Image {
                width: parent.width / 4
                height: width + units.gu(2)

                source: filename
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}

