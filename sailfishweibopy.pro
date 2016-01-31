TEMPLATE = aux

TARGET = sailfishweibopy

OTHER_FILES += \
    rpm/sailfishweibopy.changes.in \
    rpm/sailfishweibopy.spec

pycurl.files = \
    pycurl-7.19.5.3/build/usr/lib/python3.4/site-packages/*
pycurl.path = \
    /usr/lib/python3.4/site-packages/
INSTALLS += pycurl

modules.files = \
    qml/*
modules.path = \
    /usr/share/harbour-sailfish_sinaweibo/qml
INSTALLS += modules

DISTFILES += \
    qml/pages/LoginComponent.qml


win32 {
    COPY = copy /y
    MKDIR = mkdir
} else {
    COPY = cp
    MKDIR = mkdir -p
}

LIB_DIR = $$PWD/pycurl-7.19.5.3
LIB_BUILD_DIR = $$LIB_DIR/build
BUILD_LIB = cd $$LIB_DIR \
    && python3 setup.py --with-ssl install --root build
system ($$MKDIR $$LIB_BUILD_DIR)
system ($$BUILD_LIB)
