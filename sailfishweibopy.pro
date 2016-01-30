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

