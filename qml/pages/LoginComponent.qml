import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import harbour.sailfish_sinaweibo.sunrain 1.0

Page {
    id:pyLoginPage
    property string api_key:"1011524190"
    property string api_secret:"83822a8addf08cbcdaca75c76bec558a"
    property string redirect_uri:"https://api.weibo.com/oauth2/default.html"
    signal loginSucceed()
    signal loginFailed(string fail)

    CookieDataProvider {
        id: cookie;
        onPreLoginSuccess: {
            captchaImg.source = cookie.captchaImgUrl;
            captchaImg.visible = true;
            captchaImg.enabled = true;
        }
        onPreLoginFailure: { //str
            errorLabel.text = qsTr("Try hack login failure on prelogin, error code is")
            + "[" + str +"]."
        }
        onLoginSuccess: {
            console.log("Hack login success, start manual login now");
            doPyLogin()
        }
        onLoginFailure: { //str
            console.log("Try hack login failure [" + str +"], start manual login now");
            doPyLogin()
        }
    }

    Component.onCompleted: {
        cookie.preLogin();
    }

    function doPyLogin() {
        py.login(api_key,api_secret,redirect_uri,userName.text,password.text)
    }

    SilicaFlickable {
        anchors.fill: parent

        BusyIndicator {
            id:busyIndicator
            parent: pyLoginPage
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
        }
        PullDownMenu {
            id: pdMenu
            MenuItem {
                id: manualBtn
                text: qsTr("Manual Autheticator")
                onClicked: {
                    //pageStack.replace("qrc:/pages/LoginPage.qml");
                    toLoginPage();
                }
            }
            MenuItem {
                text: qsTr("User Password Autheticator")
                onClicked: {
                    pageStack.replace(Qt.resolvedUrl("file:///usr/share/harbour-sailfish_sinaweibo/qml/pages/LoginComponent.qml"));
                }
            }
            MenuItem {
                text: qsTr("Help")
                onClicked: {
                    //pageStack.replace("qrc:/pages/LoginPage.qml");
                    toLoginPage();
                }
            }
        }

        Column {
            id:column
            anchors{
                top:parent.top
                topMargin: Theme.paddingLarge*4
                horizontalCenter: parent.horizontalCenter
            }

            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("User Password Autheticator")
            }

            Rectangle {
                id:rectangle
                width: input.width + Theme.paddingMedium*2
                height: input.height + Theme.paddingMedium*2
                border.color:Theme.highlightColor
                color:"#00000000"
                radius: 30
                Column {
                    id:input
                    anchors{
                        top:rectangle.top
                        topMargin: Theme.paddingMedium
                    }

                    spacing: Theme.paddingMedium

                    TextField {
                        id:userName
                        width:pyLoginPage.width - Theme.paddingLarge*4
                        height:implicitHeight
                        inputMethodHints:Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly
                        font.pixelSize: Theme.fontSizeMedium
                        placeholderText: qsTr("Enter Email")
                        label: qsTr("UserName")
                        EnterKey.enabled: text || inputMethodComposing
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: password.focus = true
                    }
                    TextField {
                        id:password
                        width:pyLoginPage.width - Theme.paddingLarge*4
                        height:implicitHeight
                        echoMode: TextInput.Password
                        font.pixelSize: Theme.fontSizeMedium
                        placeholderText: qsTr("Enter Password")
                        label: qsTr("Password")
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: {
                            if (captchaImg.visible)
                                submitButton.focus
                            else
                                cap.focus = true
//                            errorLabel.visible = false;
//                            busyIndicator.running = true;
//                            py.login(api_key,api_secret,redirect_uri,userName.text,password.text)
                        }
                    }
                    Image {
                        id: captchaImg
                        width: parent.width *0.8
                        height: Theme.itemSizeSmall
                        x: Theme.horizontalPageMargin
                        fillMode: Image.PreserveAspectFit
                        visible: false;
                        enabled: false;
                    }
                    TextField {
                        id:cap
                        width:pyLoginPage.width - Theme.paddingLarge*4
                        height:implicitHeight
                        visible: captchaImg.visible
                        enabled: captchaImg.visible
                        echoMode: TextInput.Password
                        font.pixelSize: Theme.fontSizeMedium
                        placeholderText: qsTr("Enter captcha")
                        label: qsTr("Captcha")
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: {
                            submitButton.focus = true
//                            errorLabel.visible = false;
//                            busyIndicator.running = true;
//                            py.login(api_key,api_secret,redirect_uri,userName.text,password.text)
                        }
                    }
                }
            }
            Button {
                id:submitButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Login")
                enabled:userName.text && password.text
                onClicked: {
                    errorLabel.visible = false;
                    busyIndicator.running = true;
//                    py.login(api_key,api_secret,redirect_uri,userName.text,password.text)
                    cookie.userName = userName.text;
                    cookie.passWord = password.text;
                    cookie.captcha = cap.text;
                    cookie.login();
                }
            }
        }

        Label {
            id:errorLabel
            anchors{
                top:column.bottom
                topMargin: Theme.paddingLarge * 2
                bottom: parent.bottom
                bottomMargin: Theme.paddingLarge
                horizontalCenter: parent.horizontalCenter
            }
            width: column.width
            color: Theme.highlightColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }

    Python{
        id:py
        signal pyhandler(string access_token,string uid)

        onPyhandler:{
          //登录成功
          if("Error" != access_token){
            errorLabel.visible = false;
            busyIndicator.running = false;
            tokenProvider.accessToken = access_token;
            tokenProvider.uid = uid;
            console.log("Successed!")
            //pyLoginPage.loginSucceed();
            toIndexPage();
          }else{
            busyIndicator.running = false;
            errorLabel.visible = true;
            //uid暂时用来返回错误信息吧
            errorLabel.text = qsTr("Login fail")+" [ "+uid+" ]. " + qsTr("Please try again.");
          }

        }
        onError: {
          busyIndicator.running = false;
          errorLabel.visible = true;
          errorLabel.text = traceback;
        }
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'));
            py.importModule('main', function () {
            });
            setHandler('pyhandler', pyhandler);
        }
        function login(api_key,api_secret,redirect_uri,username,password){
            call('main.login',[api_key,api_secret,redirect_uri,username,password],function(result){
                //return result
            })
        }
    }
}
