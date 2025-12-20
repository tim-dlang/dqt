/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.core.textcodec;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.list;
import qt.core.qchar;
import qt.core.string;
import qt.core.stringview;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(textcodec); +/




/// Binding for C++ class [QTextCodec](https://doc.qt.io/qt-5/qtextcodec.html).
abstract class /+ Q_CORE_EXPORT +/ QTextCodec
{
private:
    /+ Q_DISABLE_COPY(QTextCodec) +/
public:
    static QTextCodec codecForName(ref const(QByteArray) name);
    static QTextCodec codecForName(const(char)* name) { auto tmp = QByteArray(name); return codecForName(tmp); }
    static QTextCodec codecForMib(int mib);

    static QList!(QByteArray) availableCodecs();
    static QList!(int) availableMibs();

    static QTextCodec codecForLocale();
    static void setCodecForLocale(QTextCodec c);

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static QTextCodec *codecForTr() { return codecForMib(106); /* Utf8 */ }
#endif +/

    static QTextCodec codecForHtml(ref const(QByteArray) ba);
    static QTextCodec codecForHtml(ref const(QByteArray) ba, QTextCodec defaultCodec);

    static QTextCodec codecForUtfText(ref const(QByteArray) ba);
    static QTextCodec codecForUtfText(ref const(QByteArray) ba, QTextCodec defaultCodec);

    final bool canEncode(QChar) const;
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        final bool canEncode(ref const(QString)) const;
    }
    final bool canEncode(QStringView) const;

    final QString toUnicode(ref const(QByteArray)) const;
    final QString toUnicode(const(char)* chars) const;
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        final QByteArray fromUnicode(ref const(QString) uc) const;
    }
    final QByteArray fromUnicode(QStringView uc) const;
    enum ConversionFlag {
        DefaultConversion,
        ConvertInvalidToNull = 0x80000000,
        IgnoreHeader = 0x1,
        FreeFunction = 0x2
    }
    /+ Q_DECLARE_FLAGS(ConversionFlags, ConversionFlag) +/
alias ConversionFlags = QFlags!(ConversionFlag);
    struct /+ Q_CORE_EXPORT +/ ConverterState {
        this(ConversionFlags f/+ = ConversionFlag.DefaultConversion+/)
        {
            this.flags = f;
            this.remainingChars = 0;
            this.invalidChars = 0;
            this.d = null;
            state_data[0] = state_data[1] = state_data[2] = 0;
        }
        ~this();
        ConversionFlags flags = ConversionFlag.DefaultConversion;
        int remainingChars = 0;
        int invalidChars = 0;
        uint[3] state_data = [0, 0, 0];
        void* d = null;
    private:
        /+ Q_DISABLE_COPY(ConverterState) +/
@disable this(this);
/+@disable this(ref const(ConverterState));+//+@disable ref ConverterState operator =(ref const(ConverterState));+/    }

    final QString toUnicode(const(char)* in_, int length, ConverterState* state = null) const
        { return convertToUnicode(in_, length, state); }
    final QByteArray fromUnicode(const(QChar)* in_, int length, ConverterState* state = null) const
        { return convertFromUnicode(in_, length, state); }

    final QTextDecoder* makeDecoder(ConversionFlags flags = ConversionFlag.DefaultConversion) const;
    final QTextEncoder* makeEncoder(ConversionFlags flags = ConversionFlag.DefaultConversion) const;

    /+ virtual +/ abstract QByteArray name() const;
    /+ virtual +/ QList!(QByteArray) aliases() const;
    /+ virtual +/ abstract int mibEnum() const;

protected:
    /+ virtual +/ abstract QString convertToUnicode(const(char)* in_, int length, ConverterState* state) const;
    /+ virtual +/ abstract QByteArray convertFromUnicode(const(QChar)* in_, int length, ConverterState* state) const;

    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this();
    }));
    /+ virtual +/~this();

private:
    /+ friend struct QCoreGlobalData; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QTextCodec.ConversionFlags.enum_type) operator |(QTextCodec.ConversionFlags.enum_type f1, QTextCodec.ConversionFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextCodec.ConversionFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTextCodec.ConversionFlags.enum_type) operator |(QTextCodec.ConversionFlags.enum_type f1, QFlags!(QTextCodec.ConversionFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTextCodec.ConversionFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTextCodec::ConversionFlags) +/
/// Binding for C++ class [QTextEncoder](https://doc.qt.io/qt-5/qtextencoder.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QTextEncoder {
private:
    /+ Q_DISABLE_COPY(QTextEncoder) +/
@disable this(this);
/+@disable this(ref const(QTextEncoder));+//+@disable ref QTextEncoder operator =(ref const(QTextEncoder));+/public:
    /+ explicit +/this(const(QTextCodec) codec)
    {
        this.c = codec;
        this.state = typeof(this.state)();
    }
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(const(QTextCodec) codec, QTextCodec.ConversionFlags flags);
    }));
    ~this();
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        QByteArray fromUnicode(ref const(QString) str);
    }
    QByteArray fromUnicode(QStringView str);
    QByteArray fromUnicode(const(QChar)* uc, int len);
    bool hasFailure() const;
private:
    const(QTextCodec) c;
    QTextCodec.ConverterState state;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QTextDecoder](https://doc.qt.io/qt-5/qtextdecoder.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QTextDecoder {
private:
    /+ Q_DISABLE_COPY(QTextDecoder) +/
@disable this(this);
/+@disable this(ref const(QTextDecoder));+//+@disable ref QTextDecoder operator =(ref const(QTextDecoder));+/public:
    /+ explicit +/this(const(QTextCodec) codec)
    {
        this.c = codec;
        this.state = typeof(this.state)();
    }
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(const(QTextCodec) codec, QTextCodec.ConversionFlags flags);
    }));
    ~this();
    QString toUnicode(const(char)* chars, int len);
    QString toUnicode(ref const(QByteArray) ba);
    void toUnicode(QString* target, const(char)* chars, int len);
    bool hasFailure() const;
    bool needsMoreData() const;
private:
    const(QTextCodec) c;
    QTextCodec.ConverterState state;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

