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
module qt.gui.picture;
extern(C++):

import qt.config;
import qt.helpers;
version (QT_NO_PICTURE) {} else
{
    import qt.core.datastream;
    import qt.core.iodevice;
    import qt.core.rect;
    import qt.core.shareddata;
    import qt.core.string;
    import qt.core.typeinfo;
    import qt.gui.paintdevice;
    import qt.gui.paintengine;
    import qt.gui.painter;
}

version (QT_NO_PICTURE) {} else
{

extern(C++, class) struct QPicturePrivate;
/// Binding for C++ class [QPicture](https://doc.qt.io/qt-6/qpicture.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPicture
{
private:
    immutable void *vtbl;
    QPaintDeviceFakeInheritance baseQPaintDeviceInterface;

    public QPaintDevice paintDevice() return
    {
        return cast(QPaintDevice)&this;
    }

    alias PaintDeviceMetric = QPaintDevice.PaintDeviceMetric;

private:
    /+ Q_DECLARE_PRIVATE(QPicture) +/
public:
    @disable this();
    /+ explicit +/this(int formatVersion/+ = -1+/);
    @disable this(this);
    this(ref const(QPicture) );
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    ~this();
    }));

    bool isNull() const;

    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    int devType() const;
    }));
    uint size() const;
    const(char)* data() const;
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    /+ virtual +/ void setData(const(char)* data, uint size);
    }));

    bool play(QPainter* p);

    bool load(QIODevice dev);
    bool load(ref const(QString) fileName);
    bool save(QIODevice dev);
    bool save(ref const(QString) fileName);

    QRect boundingRect() const;
    void setBoundingRect(ref const(QRect) r);

    /+ref QPicture operator =(ref const(QPicture) p);+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QPicture) +/
    /+ inline void swap(QPicture &other) noexcept
    { d_ptr.swap(other.d_ptr); } +/
    void detach();
    bool isDetached() const;

    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &in, const QPicture &p); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &in, QPicture &p); +/

    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    QPaintEngine paintEngine() const;
    }));

protected:
    this(ref QPicturePrivate data);

    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    int metric(PaintDeviceMetric m) const;
    }));

private:
    bool exec(QPainter* p, ref QDataStream ds, int i);

    QExplicitlySharedDataPointer!(QPicturePrivate) d_ptr;
    /+ friend class QPicturePaintEngine; +/
    /+ friend class QAlphaPaintEngine; +/
    /+ friend class QPreviewPaintEngine; +/

public:
    alias DataPtr = QExplicitlySharedDataPointer!(QPicturePrivate);
    pragma(inline, true) ref DataPtr data_ptr() return { return d_ptr; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QPicture)

/*****************************************************************************
  QPicture stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPicture &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPicture &);
#endif +/

}
version (QT_NO_PICTURE)
{
extern(C++, class) struct QPicture;
}


