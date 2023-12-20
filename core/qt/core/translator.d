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
module qt.core.translator;
extern(C++):

import qt.config;
import qt.helpers;
version (QT_NO_TRANSLATION) {} else
{
    import qt.core.global;
    import qt.core.locale;
    import qt.core.object;
    import qt.core.string;
}

version (QT_NO_TRANSLATION)
{
class QTranslator;
}

version (QT_NO_TRANSLATION) {} else
{

extern(C++, class) struct QTranslatorPrivate;

/// Binding for C++ class [QTranslator](https://doc.qt.io/qt-5/qtranslator.html).
class /+ Q_CORE_EXPORT +/ QTranslator : QObject
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    /+ virtual +/ QString translate(const(char)* context, const(char)* sourceText,
                                  const(char)* disambiguation = null, int n = -1) const;

    /+ virtual +/ bool isEmpty() const;

    final QString language() const;
    final QString filePath() const;

    final bool load(ref const(QString)  filename,
                  ref const(QString)  directory = globalInitVar!QString,
                  ref const(QString)  search_delimiters = globalInitVar!QString,
                  ref const(QString)  suffix = globalInitVar!QString);
    final bool load(ref const(QLocale)  locale,
                  ref const(QString)  filename,
                  ref const(QString)  prefix = globalInitVar!QString,
                  ref const(QString)  directory = globalInitVar!QString,
                  ref const(QString)  suffix = globalInitVar!QString);
    final bool load(const(uchar)* data, int len, ref const(QString) directory = globalInitVar!QString);

private:
    /+ Q_DISABLE_COPY(QTranslator) +/
    /+ Q_DECLARE_PRIVATE(QTranslator) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

}

