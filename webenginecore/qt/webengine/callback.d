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
module qt.webengine.callback;
extern(C++):

import qt.config;
import qt.core.shareddata;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct CallbackDirectory;
}


extern(C++, "QtWebEnginePrivate") {

abstract class QWebEngineCallbackPrivateBase(T) : QSharedData {
public:
    this() {}
    /+ virtual +/~this() {}
    /+/+ virtual +/ abstract void operator ()(T);+/
}

class QWebEngineCallbackPrivate(T, F) : QWebEngineCallbackPrivateBase!(T) {
public:
    this(F callable)
    {
        this.m_callable = callable;
    }
    /+override void operator ()(T value) { m_callable(value); }+/

private:
    F m_callable;
}

} // namespace QtWebEnginePrivate

extern(C++, class) struct QWebEngineCallback(T) {
public:
    /+ template<typename F> +/
    this(F)(F f)
    {
        import core.stdcpp.new_;
        this.d = UnresolvedMergeConflict!(q{cpp_new!/+ QtWebEnginePrivate:: +/QWebEngineCallbackPrivate!(T, F)(f)},q{cpp_new!QWebEngineCallbackPrivate<T,F>(f)});
    }
    @disable this();
    /+this() {}+/
    /+ void swap(QWebEngineCallback &other) Q_DECL_NOTHROW { qSwap(d, other.d); } +/
    /+auto opCast(T : bool)() const { return cast(bool) (d); }+/

private:
    /+ friend class QtWebEngineCore::CallbackDirectory; +/
    QExplicitlySharedDataPointer!(ValueClass!(/+ QtWebEnginePrivate:: +/QWebEngineCallbackPrivateBase!(T))) d;
}

/+ Q_DECLARE_SHARED(QWebEngineCallback<int>)
Q_DECLARE_SHARED(QWebEngineCallback<const QByteArray &>)
Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QWebEngineCallback<bool>)
Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QWebEngineCallback<const QString &>)
Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QWebEngineCallback<const QVariant &>) +/

