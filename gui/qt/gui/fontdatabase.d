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
module qt.gui.fontdatabase;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.objectdefs;
import qt.core.string;
import qt.core.stringlist;
import qt.gui.font;
import qt.gui.fontinfo;
import qt.helpers;

/+ class QStringList;
template <class T> class QList; +/
struct QFontDef;
extern(C++, class) struct QFontEngine;

extern(C++, class) struct QFontDatabasePrivate;

/// Binding for C++ class [QFontDatabase](https://doc.qt.io/qt-5/qfontdatabase.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QFontDatabase
{
    mixin(Q_GADGET);
public:
    // do not re-order or delete entries from this enum without updating the
    // QPF2 format and makeqpf!!
    enum WritingSystem {
        Any,

        Latin,
        Greek,
        Cyrillic,
        Armenian,
        Hebrew,
        Arabic,
        Syriac,
        Thaana,
        Devanagari,
        Bengali,
        Gurmukhi,
        Gujarati,
        Oriya,
        Tamil,
        Telugu,
        Kannada,
        Malayalam,
        Sinhala,
        Thai,
        Lao,
        Tibetan,
        Myanmar,
        Georgian,
        Khmer,
        SimplifiedChinese,
        TraditionalChinese,
        Japanese,
        Korean,
        Vietnamese,

        Symbol,
        Other = WritingSystem.Symbol,

        Ogham,
        Runic,
        Nko,

        WritingSystemsCount
    }
    /+ Q_ENUM(WritingSystem) +/

    enum SystemFont {
        GeneralFont,
        FixedFont,
        TitleFont,
        SmallestReadableFont
    }
    /+ Q_ENUM(SystemFont) +/

    static QList!(int) standardSizes();

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }


    QList!(WritingSystem) writingSystems() const;
    QList!(WritingSystem) writingSystems(ref const(QString) family) const;

    QStringList families(WritingSystem writingSystem = WritingSystem.Any) const;
    QStringList styles(ref const(QString) family) const;
    QList!(int) pointSizes(ref const(QString) family, ref const(QString) style = globalInitVar!QString);
    QList!(int) smoothSizes(ref const(QString) family, ref const(QString) style);
    QString styleString(ref const(QFont) font);
    QString styleString(ref const(QFontInfo) fontInfo);

    QFont font(ref const(QString) family, ref const(QString) style, int pointSize) const;

    bool isBitmapScalable(ref const(QString) family, ref const(QString) style = globalInitVar!QString) const;
    bool isSmoothlyScalable(ref const(QString) family, ref const(QString) style = globalInitVar!QString) const;
    bool isScalable(ref const(QString) family, ref const(QString) style = globalInitVar!QString) const;
    bool isFixedPitch(ref const(QString) family, ref const(QString) style = globalInitVar!QString) const;

    bool italic(ref const(QString) family, ref const(QString) style) const;
    bool bold(ref const(QString) family, ref const(QString) style) const;
    int weight(ref const(QString) family, ref const(QString) style) const;

    bool hasFamily(ref const(QString) family) const;
    bool isPrivateFamily(ref const(QString) family) const;

    static QString writingSystemName(WritingSystem writingSystem);
    static QString writingSystemSample(WritingSystem writingSystem);

    static int addApplicationFont(ref const(QString) fileName);
    static int addApplicationFontFromData(ref const(QByteArray) fontData);
    static QStringList applicationFontFamilies(int id);
    static bool removeApplicationFont(int id);
    static bool removeAllApplicationFonts();

/+ #if QT_DEPRECATED_SINCE(5, 2) +/
    /+ QT_DEPRECATED +/ static bool supportsThreadedFontRendering();
/+ #endif +/

    static QFont systemFont(SystemFont type);

private:
    static void createDatabase();
    static void parseFontName(ref const(QString) name, ref QString foundry, ref QString family);
    static QString resolveFontFamilyAlias(ref const(QString) family);
    static QFontEngine* findFont(ref const(QFontDef) request, int script /* QChar::Script */);
    static void load(const(QFontPrivate)* d, int script /* QChar::Script */);

    /+ friend struct QFontDef; +/
    /+ friend class QFontPrivate; +/
    /+ friend class QFontDialog; +/
    /+ friend class QFontDialogPrivate; +/
    /+ friend class QFontEngineMulti; +/
    /+ friend class QRawFont; +/

    QFontDatabasePrivate* d;
}

