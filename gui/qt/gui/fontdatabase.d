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
import qt.core.metamacros;
import qt.core.string;
import qt.core.stringlist;
import qt.gui.font;
import qt.gui.fontinfo;
import qt.helpers;

struct QFontDef;
extern(C++, class) struct QFontEngine;

/// Binding for C++ class [QFontDatabase](https://doc.qt.io/qt-6/qfontdatabase.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QFontDatabase
{
    mixin(Q_GADGET);
public:
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

    static if (!versionIsSet!("QT_BUILD_GUI_LIB"))
    {
        /+ QT_DEPRECATED_VERSION_X_6_0("Call the static functions instead") explicit QFontDatabase() = default; +/
    }
    else
    {
        @disable this();
        pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
        @disable void rawConstructor();
        static typeof(this) create()
        {
            typeof(this) r = typeof(this).init;
            r.rawConstructor();
            return r;
        }

    }

    static QList!(WritingSystem) writingSystems();
    static QList!(WritingSystem) writingSystems(ref const(QString) family);

    static QStringList families(WritingSystem writingSystem = WritingSystem.Any);
    static QStringList styles(ref const(QString) family);
    static QList!(int) pointSizes(ref const(QString) family, ref const(QString) style = globalInitVar!QString);
    static QList!(int) smoothSizes(ref const(QString) family, ref const(QString) style);
    static QString styleString(ref const(QFont) font);
    static QString styleString(ref const(QFontInfo) fontInfo);

    static QFont font(ref const(QString) family, ref const(QString) style, int pointSize);

    static bool isBitmapScalable(ref const(QString) family, ref const(QString) style = globalInitVar!QString);
    static bool isSmoothlyScalable(ref const(QString) family, ref const(QString) style = globalInitVar!QString);
    static bool isScalable(ref const(QString) family, ref const(QString) style = globalInitVar!QString);
    static bool isFixedPitch(ref const(QString) family, ref const(QString) style = globalInitVar!QString);

    static bool italic(ref const(QString) family, ref const(QString) style);
    static bool bold(ref const(QString) family, ref const(QString) style);
    static int weight(ref const(QString) family, ref const(QString) style);

    static bool hasFamily(ref const(QString) family);
    static bool isPrivateFamily(ref const(QString) family);

    static QString writingSystemName(WritingSystem writingSystem);
    static QString writingSystemSample(WritingSystem writingSystem);

    static int addApplicationFont(ref const(QString) fileName);
    static int addApplicationFontFromData(ref const(QByteArray) fontData);
    static QStringList applicationFontFamilies(int id);
    static bool removeApplicationFont(int id);
    static bool removeAllApplicationFonts();

    static QFont systemFont(SystemFont type);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

