
@ECHO OFF
set MER_SSH_SHARED_HOME=C:/Project
::Source tree directory is usually the working directory
set SOURCE_TREE=SailfishWeibo/WeiboPyModule/pycurl-7.19.5.3

::Directory relative to the shared home folder of the SDK
set SOURCE_RELATIVE=%MER_SSH_SHARED_HOME%/%SOURCE_TREE%

::Relative path of source tree in SDK VM
set TARGET_PATH=%SOURCE_RELATIVE%

::Set this to "SailfishOS Device" or whatever target you
::want to deploy your application to.
set DEPLOYMENT_DEVICE="SailfishOS Emulator"

set MER_SSH_PORT=2222
set MER_SSH_USERNAME=mersdk
set MER_SSH_PRIVATE_KEY=C:/SailfishOS/vmshare/ssh/private_keys/engine/mersdk

set SSH_BIN="C:\Program Files\Git\usr\bin\ssh.exe"

set MER_SSH_TARGET_NAME=SailfishOS-armv7hl
set SSH_EXEC=%SSH_BIN% -p %MER_SSH_PORT% -l %MER_SSH_USERNAME% -i %MER_SSH_PRIVATE_KEY% localhost 


::sb2 -t SailfishOS-i486 -m sdk-install -R zypper --non-interactive install libcurl-devel libidn-devel libpython3_4m1_0 openssl-devel python3-base python3-devel
::zypper --non-interactive install libcurl-devel libidn-devel libpython3_4m1_0 openssl-devel python3-base python3-devel

::install build require libs
%SSH_EXEC% sb2 -t %MER_SSH_TARGET_NAME% -m sdk-install -R zypper --non-interactive install libcurl-devel libidn-devel libpython3_4m1_0 openssl-devel python3-base python3-devel

%SSH_EXEC% sb2 -t %MER_SSH_TARGET_NAME% mkdir ../src1/%SOURCE_TREE%/build

%SSH_EXEC% 'cd ../src1/%SOURCE_TREE%; sb2 -t %MER_SSH_TARGET_NAME% python3 setup.py --with-ssl install --root build'

