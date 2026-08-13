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
module qt.gui.surface;
extern(C++):

import qt.config;
import qt.core.metamacros;
import qt.core.size;
import qt.gui.surfaceformat;
import qt.helpers;

extern(C++, class) struct QPlatformSurface;

extern(C++, class) struct QSurfacePrivate;

interface QSurfaceInterface
{
    alias SurfaceType = QSurface.SurfaceType;

    mixin(DECLARE_FAKE_INTERFACE_DESTRUCTOR);

    /+ virtual +/ QSurfaceFormat format() const;
    /+ virtual +/ QPlatformSurface* surfaceHandle() const;

    /+ virtual +/ SurfaceType surfaceType() const;

    /+ virtual +/ QSize size() const;
}

/// Binding for C++ class [QSurface](https://doc.qt.io/qt-6/qsurface.html).
abstract class /+ Q_GUI_EXPORT +/ QSurface
{
    mixin(Q_GADGET);
public:
    enum SurfaceClass {
        Window,
        Offscreen
    }
    /+ Q_ENUM(SurfaceClass) +/

    enum SurfaceType {
        RasterSurface,
        OpenGLSurface,
        RasterGLSurface,
        OpenVGSurface,
        VulkanSurface,
        MetalSurface,
        Direct3DSurface
    }
    /+ Q_ENUM(SurfaceType) +/

    /+ virtual +/~this();

    final SurfaceClass surfaceClass() const;

    /+ virtual +/ abstract QSurfaceFormat format() const;
    /+ virtual +/ abstract QPlatformSurface* surfaceHandle() const;

    /+ virtual +/ abstract SurfaceType surfaceType() const;
    final bool supportsOpenGL() const;

    /+ virtual +/ abstract QSize size() const;

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(SurfaceClass type);
    }));

    SurfaceClass m_type;

    QSurfacePrivate* m_reserved;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ QT_DECL_METATYPE_EXTERN_TAGGED(QSurface*, QSurface_ptr, Q_GUI_EXPORT) +/

static assert(__traits(classInstanceSize, QSurface) == (void*).sizeof * 3);
struct QSurfaceFakeInheritance
{
    static assert(__traits(classInstanceSize, QSurface) % (void*).sizeof == 0);
    void*[__traits(classInstanceSize, QSurface) / (void*).sizeof - 1] data;
}
