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
module qt.gui.texttable;
extern(C++):

import qt.config;
import qt.gui.textcursor;
import qt.gui.textdocument;
import qt.gui.textformat;
import qt.gui.textobject;
import qt.helpers;

/+ class QTextCursor;
class QTextTable; +/
extern(C++, class) struct QTextTablePrivate;

extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextTableCell
{
public:
    @disable this();
    /+this()
    {
        this.table = null;
    }+/
    ~this() {}
    @disable this(this);
    this(ref const(QTextTableCell) o)
    {
        this.table = o.table;
        this.fragment = o.fragment;
    }
    /+ref QTextTableCell operator =(ref const(QTextTableCell) o)
    { table = o.table; fragment = o.fragment; return this; }+/

    void setFormat(ref const(QTextCharFormat) format);
    QTextCharFormat format() const;

    int row() const;
    int column() const;

    int rowSpan() const;
    int columnSpan() const;

    pragma(inline, true) bool isValid() const { return table !is null; }

    QTextCursor firstCursorPosition() const;
    QTextCursor lastCursorPosition() const;
    int firstPosition() const;
    int lastPosition() const;

    /+pragma(inline, true) bool operator ==(ref const(QTextTableCell) other) const
    { return table == other.table && fragment == other.fragment; }+/
    /+pragma(inline, true) bool operator !=(ref const(QTextTableCell) other) const
    { return !operator==(other); }+/

    QTextFrame.iterator begin() const;
    QTextFrame.iterator end() const;

    int tableCellFormatIndex() const;

private:
    /+ friend class QTextTable; +/
    this(const(QTextTable) t, int f)
    {
        this.table = t;
        this.fragment = f;
    }

    const(QTextTable) table = null;
    int fragment;
}

class /+ Q_GUI_EXPORT +/ QTextTable : QTextFrame
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QTextDocument doc);
    ~this();

    final void resize(int rows, int cols);
    final void insertRows(int pos, int num);
    final void insertColumns(int pos, int num);
    final void appendRows(int count);
    final void appendColumns(int count);
    final void removeRows(int pos, int num);
    final void removeColumns(int pos, int num);

    final void mergeCells(int row, int col, int numRows, int numCols);
    final void mergeCells(ref const(QTextCursor) cursor);
    final void splitCell(int row, int col, int numRows, int numCols);

    final int rows() const;
    final int columns() const;

    final QTextTableCell cellAt(int row, int col) const;
    final QTextTableCell cellAt(int position) const;
    final QTextTableCell cellAt(ref const(QTextCursor) c) const;

    final QTextCursor rowStart(ref const(QTextCursor) c) const;
    final QTextCursor rowEnd(ref const(QTextCursor) c) const;

    final void setFormat(ref const(QTextTableFormat) format);
    final QTextTableFormat format() const { return QTextObject.format().toTableFormat(); }

private:
    /+ Q_DISABLE_COPY(QTextTable) +/
    /+ Q_DECLARE_PRIVATE(QTextTable) +/
    /+ friend class QTextTableCell; +/
}

