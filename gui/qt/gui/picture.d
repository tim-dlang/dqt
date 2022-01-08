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
version(QT_NO_PICTURE){}else
{
    import qt.core.bytearray;
    import qt.core.datastream;
    import qt.core.iodevice;
    import qt.core.list;
    import qt.core.rect;
    import qt.core.shareddata;
    import qt.core.string;
    import qt.core.stringlist;
    import qt.core.typeinfo;
    import qt.gui.paintdevice;
    import qt.gui.paintengine;
    import qt.gui.painter;
}

version(QT_NO_PICTURE){}else
{

extern(C++, class) struct QPicturePrivate;
/// Binding for C++ class [QPicture](https://doc.qt.io/qt-5/qpicture.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPicture
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
    mixin(mangleWindows("??1QPicture@@UEAA@XZ", q{
    ~this();
    }));

    bool isNull() const;

    int devType() const;
    uint size() const;
    const(char)* data() const;
    /+ virtual +/ void setData(const(char)* data, uint size);

    bool play(QPainter* p);

    bool load(QIODevice dev, const(char)* format = null);
    bool load(ref const(QString) fileName, const(char)* format = null);
    bool save(QIODevice dev, const(char)* format = null);
    bool save(ref const(QString) fileName, const(char)* format = null);

    QRect boundingRect() const;
    void setBoundingRect(ref const(QRect) r);

    /+ref QPicture operator =(ref const(QPicture) p);+/
    /+ inline QPicture &operator=(QPicture &&other) noexcept
    { qSwap(d_ptr, other.d_ptr); return *this; } +/
    /+ inline void swap(QPicture &other) noexcept
    { d_ptr.swap(other.d_ptr); } +/
    void detach();
    bool isDetached() const;

    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &in, const QPicture &p); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &in, QPicture &p); +/

/+ #if QT_DEPRECATED_SINCE(5, 10) +/
    /+ QT_DEPRECATED +/ static const(char)* pictureFormat(ref const(QString) fileName);
    /+ QT_DEPRECATED +/ static QList!(QByteArray) inputFormats();
    /+ QT_DEPRECATED +/ static QList!(QByteArray) outputFormats();
    /+ QT_DEPRECATED +/ static QStringList inputFormatList();
    /+ QT_DEPRECATED +/ static QStringList outputFormatList();
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 10)

    QPaintEngine paintEngine() const;

protected:
    this(ref QPicturePrivate data);

    int metric(PaintDeviceMetric m) const;

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

/+ Q_DECLARE_SHARED(QPicture) +/


static if(!defined!"QT_NO_PICTUREIO")
{
alias picture_io_handler = ExternCPPFunc!(void function(QPictureIO* )); // picture IO handler

struct QPictureIOData;

/// Binding for C++ class [QPictureIO](https://doc.qt.io/qt-5/qpictureio.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPictureIO
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(QIODevice ioDevice, const(char)* format);
    this(ref const(QString) fileName, const(char)* format);
    ~this();

    ref const(QPicture) picture() const;
    int status() const;
    const(char)* format() const;
    QIODevice ioDevice() const;
    QString fileName() const;
    int quality() const;
    QString description() const;
    const(char)* parameters() const;
    float gamma() const;

    void setPicture(ref const(QPicture) );
    void setStatus(int);
    void setFormat(const(char)* );
    void setIODevice(QIODevice );
    void setFileName(ref const(QString) );
    void setQuality(int);
    void setDescription(ref const(QString) );
    void setParameters(const(char)* );
    void setGamma(float);

    bool read();
    bool write();

    static QByteArray pictureFormat(ref const(QString) fileName);
    static QByteArray pictureFormat(QIODevice );
    static QList!(QByteArray) inputFormats();
    static QList!(QByteArray) outputFormats();

    static void defineIOHandler(const(char)* format,
                                    const(char)* header,
                                    const(char)* flags,
                                    picture_io_handler read_picture,
                                    picture_io_handler write_picture);

private:
    /+ Q_DISABLE_COPY(QPictureIO) +/
@disable this(this);
/+this(ref const(QPictureIO));+//+ref QPictureIO operator =(ref const(QPictureIO));+/
    void init_();

    QPictureIOData* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

}


/*****************************************************************************
  QPicture stream functions
 *****************************************************************************/

/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPicture &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPicture &);
#endif +/

}
version(QT_NO_PICTURE)
{
extern(C++, class) struct QPicture;
}


