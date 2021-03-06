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
module qt.gui.fontmetrics;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.font;
import qt.gui.paintdevice;
import qt.helpers;

/+ #ifndef QT_INCLUDE_COMPAT
#endif +/






/// Binding for C++ class [QFontMetrics](https://doc.qt.io/qt-5/qfontmetrics.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QFontMetrics
{
public:
    /+ explicit +/this(ref const(QFont) );
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    this(ref const(QFont) font, QPaintDevice pd);
/+ #ifndef Q_QDOC +/
    // the template is necessary to make QFontMetrics(font,nullptr) and QFontMetrics(font,NULL)
    // not ambiguous. Implementation detail that should not be documented.
    /+ template<char = 0>
#endif +/
    this(ref const(QFont) font, const(QPaintDevice) pd)
    {
        this(font, const_cast!(QPaintDevice)(pd));
    }
/+ #else
    QFontMetrics(const QFont &font, const QPaintDevice *pd);
#endif +/
    @disable this(this);
    this(ref const(QFontMetrics) );
    ~this();

    /+ref QFontMetrics operator =(ref const(QFontMetrics) );+/
    /+ inline QFontMetrics &operator=(QFontMetrics &&other) noexcept
    { qSwap(d, other.d); return *this; } +/

    /+ void swap(QFontMetrics &other) noexcept
    { qSwap(d, other.d); } +/

    int ascent() const;
    int capHeight() const;
    int descent() const;
    int height() const;
    int leading() const;
    int lineSpacing() const;
    int minLeftBearing() const;
    int minRightBearing() const;
    int maxWidth() const;

    int xHeight() const;
    int averageCharWidth() const;

    bool inFont(QChar) const;
    bool inFontUcs4(uint ucs4) const;

    int leftBearing(QChar) const;
    int rightBearing(QChar) const;

/+ #if QT_DEPRECATED_SINCE(5, 11) +/
    /+ QT_DEPRECATED_X("Use QFontMetrics::horizontalAdvance") +/
        int width(ref const(QString) , int len = -1) const;
    /+ QT_DEPRECATED_X("Use QFontMetrics::horizontalAdvance") +/
        int width(ref const(QString) , int len, int flags) const;
    /+ QT_DEPRECATED_X("Use QFontMetrics::horizontalAdvance") +/
        int width(QChar) const;
/+ #endif +/

    int horizontalAdvance(ref const(QString) , int len = -1) const;
    int horizontalAdvance(QChar) const;

/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    /+ QT_DEPRECATED +/ int charWidth(ref const(QString) str, int pos) const;
/+ #endif +/

    QRect boundingRect(QChar) const;

    QRect boundingRect(ref const(QString) text) const;
    QRect boundingRect(ref const(QRect) r, int flags, ref const(QString) text, int tabstops = 0, int* tabarray = null) const;
    pragma(inline, true) QRect boundingRect(int x, int y, int w, int h, int flags, ref const(QString) text,
                                  int tabstops = 0, int* tabarray = null) const
        { auto tmp = QRect(x, y, w, h); return boundingRect(tmp, flags, text, tabstops, tabarray); }
    QSize size(int flags, ref const(QString) str, int tabstops = 0, int* tabarray = null) const;

    QRect tightBoundingRect(ref const(QString) text) const;

    QString elidedText(ref const(QString) text, /+ Qt:: +/qt.core.namespace.TextElideMode mode, int width, int flags = 0) const;

    int underlinePos() const;
    int overlinePos() const;
    int strikeOutPos() const;
    int lineWidth() const;

    qreal fontDpi() const;

    /+bool operator ==(ref const(QFontMetrics) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QFontMetrics) other) const { return !operator==(other); }+/

private:
    /+ friend class QFontMetricsF; +/
    /+ friend class QStackTextEngine; +/

    QExplicitlySharedDataPointer!(QFontPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QFontMetrics) +/

/// Binding for C++ class [QFontMetricsF](https://doc.qt.io/qt-5/qfontmetricsf.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QFontMetricsF
{
public:
    /+ explicit +/this(ref const(QFont) font);
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    this(ref const(QFont) font, QPaintDevice pd);
/+ #ifndef Q_QDOC +/
    // the template is necessary to make QFontMetrics(font,nullptr) and QFontMetrics(font,NULL)
    // not ambiguous. Implementation detail that should not be documented.
    /+ template<char = 0>
#endif +/
    this(ref const(QFont) font, const(QPaintDevice) pd)
    {
        this(font, const_cast!(QPaintDevice)(pd));
    }
/+ #else
    QFontMetricsF(const QFont &font, const QPaintDevice *pd);
#endif +/
    this(ref const(QFontMetrics) );
    @disable this(this);
    this(ref const(QFontMetricsF) );
    ~this();

    /+ref QFontMetricsF operator =(ref const(QFontMetricsF) );+/
    /+ref QFontMetricsF operator =(ref const(QFontMetrics) );+/
    /+ inline QFontMetricsF &operator=(QFontMetricsF &&other) noexcept
    { qSwap(d, other.d); return *this; } +/

    /+ void swap(QFontMetricsF &other) noexcept { qSwap(d, other.d); } +/

    qreal ascent() const;
    qreal capHeight() const;
    qreal descent() const;
    qreal height() const;
    qreal leading() const;
    qreal lineSpacing() const;
    qreal minLeftBearing() const;
    qreal minRightBearing() const;
    qreal maxWidth() const;

    qreal xHeight() const;
    qreal averageCharWidth() const;

    bool inFont(QChar) const;
    bool inFontUcs4(uint ucs4) const;

    qreal leftBearing(QChar) const;
    qreal rightBearing(QChar) const;

/+ #if QT_DEPRECATED_SINCE(5, 11) +/
    qreal width(ref const(QString) string) const;
    qreal width(QChar) const;
/+ #endif +/

    qreal horizontalAdvance(ref const(QString) string, int length = -1) const;
    qreal horizontalAdvance(QChar) const;

    QRectF boundingRect(ref const(QString) string) const;
    QRectF boundingRect(QChar) const;
    QRectF boundingRect(ref const(QRectF) r, int flags, ref const(QString) string, int tabstops = 0, int* tabarray = null) const;
    QSizeF size(int flags, ref const(QString) str, int tabstops = 0, int* tabarray = null) const;

    QRectF tightBoundingRect(ref const(QString) text) const;

    QString elidedText(ref const(QString) text, /+ Qt:: +/qt.core.namespace.TextElideMode mode, qreal width, int flags = 0) const;

    qreal underlinePos() const;
    qreal overlinePos() const;
    qreal strikeOutPos() const;
    qreal lineWidth() const;

    qreal fontDpi() const;

    /+bool operator ==(ref const(QFontMetricsF) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QFontMetricsF) other) const { return !operator==(other); }+/

private:
    QExplicitlySharedDataPointer!(QFontPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QFontMetricsF) +/

