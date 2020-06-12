#!/usr/bin/env python

import rospy
from std_msgs.msg import String
from std_msgs.msg import Float32

from PySide2.QtCore import Slot
from PySide2.QtCore import Signal
from PySide2.QtCore import Property
from PySide2.QtCore import QUrl
from PySide2.QtCore import QObject
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQml import qmlRegisterType

import os
import sys


class Backend(QObject):
    msg_received = Signal(str)

    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self._pub_chatter = rospy.Publisher('chatter', String, queue_size=1)
        self._pub_float = rospy.Publisher('slider', Float32, queue_size=1)

        self._last_msg = None
        self._sub_chatter = rospy.Subscriber('chatter', String, self.cb_chatter, queue_size=1)

    def cb_chatter(self, msg):
        self._last_msg = msg
        self.msg_received.emit(self._last_msg.data)

    @Property(str, notify=msg_received)
    def received_data(self):
        return self._last_msg.data

    @Slot(str, str)
    def publish_string(self, topic_name, value):
        if self._pub_chatter.name != topic_name:
            self._pub_chatter = rospy.Publisher(topic_name, String, queue_size=1)
            print('Switching pub topic: {}'.format(topic_name))
            # Wait for a while for the topic to spin up
            rospy.sleep(0.5)

        msg = String()
        msg.data = value
        self._pub_chatter.publish(msg)

    @Slot(float)
    def publish_slider(self, data):
        msg = Float32()
        msg.data = data
        self._pub_float.publish(msg)


def main():
    app = QGuiApplication(sys.argv)
    qmlRegisterType(Backend, 'PythonBackendLibrary', 1, 0, 'PythonBackend')

    qml_file = 'main.qml'
    current_dir = os.path.dirname(os.path.realpath(__file__))
    filename = os.path.join(current_dir, qml_file)

    backend = Backend()
    engine = QQmlApplicationEngine()
    win = engine.rootContext()
    engine.load(QUrl.fromLocalFile(filename))

    rospy.init_node('rospy_qt_quick')

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
