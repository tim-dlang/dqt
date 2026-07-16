// QT_MODULES: widgets
// BUILD_ONLY
module testlabel1;

import qt.config;
import qt.helpers;
import qt.core.string : QString;
import qt.widgets.label : QLabel;
import qt.widgets.widget : QWidget;
import qt.widgets.application : QApplication;

// QApplication app;
// shared static this()
// {
//     import core.runtime;
//     import core.stdcpp.new_;

//     static __gshared int argc_copy;
//     argc_copy = Runtime.cArgs.argc;
//     app = cpp_new!QApplication(argc_copy, Runtime.cArgs.argv);
// }
// shared static ~this()
// {
//     import core.stdcpp.new_;

//     cpp_delete(app);
//     app = null;
// }

class TestLabel : QLabel
{
    mixin(Q_OBJECT_D);
public:
    this(QWidget parent = null)
    {
        super(parent);
        setText(QString("initial"));
    }

    @QSignal final void customTextChanged(ref const(QString) newText) { mixin(Q_SIGNAL_IMPL_D); }

    @QSlot final void setCustomText(ref const(QString) text)
    {
        setText(text);
        /+ emit +/ customTextChanged(text);
    }

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

// unittest
// {
//     scope label = new TestLabel;
//     assert(label.text() == "initial");

//     label.setCustomText("hello");
//     assert(label.text() == "hello");
// }

// unittest
// {
//     import core.stdc.string;
//     import core.stdcpp.new_;

//     const(QMetaObject)* mo = &TestLabel.staticMetaObject;
//     assert(strcmp(mo.className(), "TestLabel") == 0);
//     assert(mo.methodCount() - mo.methodOffset() >= 2);

//     TestLabel label = cpp_new!TestLabel();
//     assert(label.metaObject() == mo);
//     cpp_delete(label);
// }

// unittest
// {
//     import core.stdcpp.new_;

//     TestLabel a = cpp_new!TestLabel();
//     TestLabel b = cpp_new!TestLabel();
//     scope(exit) { cpp_delete(a); cpp_delete(b); }

//     QString lastReceived;
//     QObject.connect(a.signal!"customTextChanged", b, (ref const(QString) s) {
//         lastReceived = s;
//     });

//     a.setCustomText("test_signal");
//     assert(lastReceived == "test_signal");
//     assert(a.text() == "test_signal");
//     assert(b.text() == "initial");
// }

// unittest
// {
//     import core.stdcpp.new_;

//     TestLabel label = cpp_new!TestLabel();
//     scope(exit) cpp_delete(label);

//     assert(label.text() == "initial");

//     label.setText("updated");
//     assert(label.text() == "updated");

//     label.clear();
//     assert(label.text() == "");
// }

// unittest
// {
//     import qt.core.namespace : Alignment;

//     scope label = new TestLabel;
//     label.setAlignment(Alignment.AlignCenter);
//     assert(label.alignment() == Alignment.AlignCenter);

//     label.setWordWrap(true);
//     assert(label.wordWrap());
// }
