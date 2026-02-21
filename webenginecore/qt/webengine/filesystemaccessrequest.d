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
module qt.webengine.filesystemaccessrequest;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.metamacros;
import qt.core.object;
import qt.core.typeinfo;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct FileSystemAccessPermissionRequestController;
extern(C++, class) struct FileSystemAccessPermissionRequestManagerQt;
}


/// Binding for C++ class [QWebEngineFileSystemAccessRequest](https://doc.qt.io/qt-6/qwebenginefilesystemaccessrequest.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineFileSystemAccessRequest
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QUrl origin READ origin CONSTANT FINAL)
    Q_PROPERTY(QUrl filePath READ filePath CONSTANT FINAL)
    Q_PROPERTY(HandleType handleType READ handleType CONSTANT FINAL)
    Q_PROPERTY(AccessFlags accessFlags READ accessFlags CONSTANT FINAL) +/

public:
    @disable this(this);
    this(ref const(QWebEngineFileSystemAccessRequest) other);
    ref QWebEngineFileSystemAccessRequest opAssign(ref const(QWebEngineFileSystemAccessRequest) other);
    /+ QWebEngineFileSystemAccessRequest(QWebEngineFileSystemAccessRequest &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QWebEngineFileSystemAccessRequest) +/
    ~this();

    /+ void swap(QWebEngineFileSystemAccessRequest &other) noexcept { d_ptr.swap(other.d_ptr); } +/

    enum HandleType { File, Directory }
    /+ Q_ENUM(HandleType) +/

    enum AccessFlag { Read = 0x1, Write = 0x2 }
    /+ Q_DECLARE_FLAGS(AccessFlags, AccessFlag) +/
alias AccessFlags = QFlags!(AccessFlag);    /+ Q_FLAG(AccessFlags) +/

    @QInvokable void accept();
    @QInvokable void reject();
    QUrl origin() const;
    QUrl filePath() const;
    HandleType handleType() const;
    AccessFlags accessFlags() const;

    /+ inline friend bool operator==(const QWebEngineFileSystemAccessRequest &lhs,
                                  const QWebEngineFileSystemAccessRequest &rhs) noexcept
    { return lhs.d_ptr == rhs.d_ptr; } +/
    /+ inline friend bool operator!=(const QWebEngineFileSystemAccessRequest &lhs,
                                  const QWebEngineFileSystemAccessRequest &rhs) noexcept
    { return lhs.d_ptr != rhs.d_ptr; } +/

private:
    /+ QWebEngineFileSystemAccessRequest(
            std::shared_ptr<QtWebEngineCore::FileSystemAccessPermissionRequestController>); +/
    /+ friend QtWebEngineCore::FileSystemAccessPermissionRequestManagerQt; +/

    /+ std:: +/ /*shared_ptr!(*/ /+ QtWebEngineCore:: +/FileSystemAccessPermissionRequestController* d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) operator |(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow{return QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) operator |(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) operator &(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow{return QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) operator &(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) operator ^(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow{return QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) operator ^(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QWebEngineFileSystemAccessRequest.AccessFlags operator ~(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type e)nothrow{return~QWebEngineFileSystemAccessRequest.AccessFlags(e);}+/
/+pragma(inline, true) void operator |(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QWebEngineFileSystemAccessRequest.AccessFlags.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_SHARED(QWebEngineFileSystemAccessRequest)

Q_DECLARE_OPERATORS_FOR_FLAGS(QWebEngineFileSystemAccessRequest::AccessFlags) +/
