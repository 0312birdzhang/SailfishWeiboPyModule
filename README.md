# SailfishWeiboPyModule
Py module for SailfishWeibo

A py module for https://github.com/SunRain/SailfishWeibo ,use this module can login with your username and password

##Requires:
* pycurl https://github.com/pycurl/pycurl
* rpweibo https://github.com/WeCase/rpweibo

##Usage:
<code>pageStack.push(Qt.resolveUrl("LoginComponent.qml"))</code>

##Note:
Here's how you configure Qt Creator to build the project in windows:

1. Open the .pro file in Qt Creator

2. Modify the project build settings:

	Build Steps:

		add a new one:

		Custom Process Step

				Command: $full_path_to/build-win-$target.cmd
							note: for i486, $target is i486, for arm, $target is armv7hl
								  You may need to modify the cmd file to fit your environment
				Arguments: 
		        Working directory: %{buildDir}
		
		move this custom process step up, the build steps will be like this:
		1. start sdk
		2. custom process
		3. qmake
		4. make


# 旗鱼微博python模块

一个微博(https://github.com/SunRain/SailfishWeibo) py的模块，安装这个模块可以使用用户名密码登录

##依赖：
* pycurl https://github.com/pycurl/pycurl
* rpweibo https://github.com/WeCase/rpweibo

##使用
<code>pageStack.push(Qt.resolveUrl("LoginComponent.qml"))</code>

##注意：
以下是在windows下使用QtCreator编译的方法

1. 在Qt Creator中打开.pro文件

2. 修改项目=>构建步骤:

	构建步骤:

		添加自定义处理步骤:

		自定义处理步骤参数如下:

				命令: build-win-$target.cmd的完整路径
							注意: i486编译时, $target是i486, arm编译时, $target 是 armv7hl
								  你可能需要根据你当前的系统环境修改这两个.cmd文件里面的环境变量设置
				参数: 留空
		        工作目录: %{buildDir}
		
		将此自定义构建步骤往上移动，最终的构建顺序如下:
		1. start sdk
		2. 自定义处理步骤
		3. qmake
		4. make