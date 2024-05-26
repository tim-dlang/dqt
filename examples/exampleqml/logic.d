module exampleqml.logic;

import exampleqml.simpletablemodel;
import qt.config;
import qt.core.object;
import qt.core.string;
import qt.helpers;
import qt.quick.textdocument;

class Logic : QObject
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this(QObject parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.m_string1 = "string1";

        tableModel = cpp_new!SimpleTableModel();
        m_textStatistics = QString.create;
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(tableModel);
    }

    @QSlot final void reset()
    {
        import qt.core.variant;

        setBool1(false);
        setProperty("bool2", false);
        setString1("string1");
    }

    private bool m_bool1 = false;
    @QPropertyDef
    {
        final bool bool1() const
        {
            return m_bool1;
        }
        final void setBool1(bool bool1)
        {
            if (m_bool1 != bool1)
            {
                m_bool1 = bool1;
                /+ emit +/ bool1Changed();
            }
        }
        @QSignal final void bool1Changed() {mixin(Q_SIGNAL_IMPL_D);}
    }

    @QPropertyDef("notBool1", notify: "bool1Changed")
    {
        final bool notBool1() const
        {
            return !m_bool1;
        }
    }

    @QPropertyDef("bool2")
    {
        private bool m_bool2 = false;
        @QSignal final void bool2Changed() {mixin(Q_SIGNAL_IMPL_D);}
    }

    private QString m_string1;
    @QPropertyDef
    {
        final QString string1() const
        {
            return m_string1;
        }
        final void setString1(ref const(QString) string1)
        {
            if (m_string1 != string1)
            {
                m_string1 = string1;
                /+ emit +/ string1Changed();
            }
        }
        @QSignal final void string1Changed() {mixin(Q_SIGNAL_IMPL_D);}
    }

    @QInvokable final QString toUpper(ref const(QString) s)
    {
        return s.toUpper();
    }

    @QInvokable final void processTextDocument(QQuickTextDocument textDocument)
    {
        QString plainText = textDocument.textDocument().toPlainText();
        setTextStatistics("Words: " ~ QString.number(plainText.split(" ").length()));
    }

    private SimpleTableModel tableModel;
    @QPropertyDef("tableModel", isConstant: true) final SimpleTableModel getTableModel()
    {
        return tableModel;
    }

    private QString m_textStatistics;
    @QPropertyDef
    {
        final QString textStatistics() const
        {
            return m_textStatistics;
        }
        final void setTextStatistics(ref const(QString) textStatistics)
        {
            if (this.m_textStatistics != textStatistics)
            {
                m_textStatistics = textStatistics;
                /+ emit +/ textStatisticsChanged();
            }
        }
        @QSignal final void textStatisticsChanged() {mixin(Q_SIGNAL_IMPL_D);}
    }

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

