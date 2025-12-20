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
module qt.gui.icon;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.painter;
import qt.gui.pixmap;
import qt.gui.windowdefs;
import qt.helpers;

extern(C++, class) struct QIconPrivate;
extern(C++, class) struct QIconEngine;

/// Binding for C++ class [QIcon](https://doc.qt.io/qt-6/qicon.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QIcon
{
public:
    enum Mode { Normal, Disabled, Active, Selected }
    enum State { On, Off }

    /+this()/+ noexcept+/;+/

    this(ref const(QPixmap) pixmap);
    @disable this(this);
    this(ref const(QIcon) other);
    /+ QIcon(QIcon &&other) noexcept
        : d(qExchange(other.d, nullptr))
    {} +/
    /+ explicit +/this(ref const(QString) fileName); // file or resource name
    /+ explicit +/this(QIconEngine* engine);
    ~this();
    ref QIcon opAssign(ref const(QIcon) other);
    ref QIcon opAssign(QIcon other)
    {
        return opAssign(*cast(const(QIcon*))&other);
    }
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QIcon) +/
    /+ inline void swap(QIcon &other) noexcept
    { qt_ptr_swap(d, other.d); } +/
    /+@disable bool operator ==(ref const(QIcon) ) const;+/
    /+@disable bool operator !=(ref const(QIcon) ) const;+/

    /+auto opCast(T : QVariant)() const;+/

    QPixmap pixmap(ref const(QSize) size, Mode mode = Mode.Normal, State state = State.Off) const;
    pragma(inline, true) QPixmap pixmap(int w, int h, Mode mode = Mode.Normal, State state = State.Off) const
        { auto tmp = QSize(w, h); return pixmap(tmp, mode, state); }
    pragma(inline, true) QPixmap pixmap(int extent, Mode mode = Mode.Normal, State state = State.Off) const
        { auto tmp = QSize(extent, extent); return pixmap(tmp, mode, state); }
    QPixmap pixmap(ref const(QSize) size, qreal devicePixelRatio, Mode mode = Mode.Normal, State state = State.Off) const;
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use pixmap(size, devicePixelRatio) instead") +/
        QPixmap pixmap(QWindow* window, ref const(QSize) size, Mode mode = Mode.Normal, State state = State.Off) const;
/+ #endif +/

    QSize actualSize(ref const(QSize) size, Mode mode = Mode.Normal, State state = State.Off) const;
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use actualSize(size) instead") +/
        QSize actualSize(QWindow* window, ref const(QSize) size, Mode mode = Mode.Normal, State state = State.Off) const;
/+ #endif +/

    QString name() const;

    void paint(QPainter* painter, ref const(QRect) rect, /+ Qt:: +/qt.core.namespace.Alignment alignment = /+ Qt:: +/qt.core.namespace.AlignmentFlag.AlignCenter, Mode mode = Mode.Normal, State state = State.Off) const;
    pragma(inline, true) void paint(QPainter* painter, int x, int y, int w, int h, /+ Qt:: +/qt.core.namespace.Alignment alignment = /+ Qt:: +/qt.core.namespace.AlignmentFlag.AlignCenter, Mode mode = Mode.Normal, State state = State.Off) const
        { auto tmp = QRect(x, y, w, h); paint(painter, tmp, alignment, mode, state); }

    bool isNull() const;
    bool isDetached() const;
    void detach();

    qint64 cacheKey() const;

    void addPixmap(ref const(QPixmap) pixmap, Mode mode = Mode.Normal, State state = State.Off);
    void addFile(ref const(QString) fileName, ref const(QSize) size = globalInitVar!QSize, Mode mode = Mode.Normal, State state = State.Off);

    QList!(QSize) availableSizes(Mode mode = Mode.Normal, State state = State.Off) const;

    void setIsMask(bool isMask);
    bool isMask() const;

    static QIcon fromTheme(ref const(QString) name);
    static QIcon fromTheme(ref const(QString) name, ref const(QIcon) fallback);
    static bool hasThemeIcon(ref const(QString) name);

    static QStringList themeSearchPaths();
    static void setThemeSearchPaths(ref const(QStringList) searchpath);

    static QStringList fallbackSearchPaths();
    static void setFallbackSearchPaths(ref const(QStringList) paths);

    static QString themeName();
    static void setThemeName(ref const(QString) path);

    static QString fallbackThemeName();
    static void setFallbackThemeName(ref const(QString) name);

    /+ Q_DUMMY_COMPARISON_OPERATOR(QIcon) +/

private:
    QIconPrivate* d;
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QIcon &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QIcon &); +/
    }

public:
    alias DataPtr = QIconPrivate*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QIcon)

#if !defined(QT_NO_DATASTREAM)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QIcon &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QIcon &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QIcon &);
#endif +/

/+ Q_GUI_EXPORT +/ QString qt_findAtNxFile(ref const(QString) baseFileName, qreal targetDevicePixelRatio,
                                     qreal* sourceDevicePixelRatio = null);

