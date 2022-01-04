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
module qt.gui.inputmethod;
extern(C++):

import qt.config;
import qt.core.locale;
import qt.core.namespace;
import qt.core.object;
import qt.core.rect;
import qt.core.variant;
import qt.gui.transform;
import qt.helpers;

extern(C++, class) struct QInputMethodPrivate;

/// Binding for C++ class [QInputMethod](https://doc.qt.io/qt-5/qinputmethod.html).
class /+ Q_GUI_EXPORT +/ QInputMethod : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QInputMethod) +/
    /+ Q_PROPERTY(QRectF cursorRectangle READ cursorRectangle NOTIFY cursorRectangleChanged)
    Q_PROPERTY(QRectF anchorRectangle READ anchorRectangle NOTIFY anchorRectangleChanged)
    Q_PROPERTY(QRectF keyboardRectangle READ keyboardRectangle NOTIFY keyboardRectangleChanged)
    Q_PROPERTY(QRectF inputItemClipRectangle READ inputItemClipRectangle NOTIFY inputItemClipRectangleChanged)
    Q_PROPERTY(bool visible READ isVisible NOTIFY visibleChanged)
    Q_PROPERTY(bool animating READ isAnimating NOTIFY animatingChanged)
    Q_PROPERTY(QLocale locale READ locale NOTIFY localeChanged)
    Q_PROPERTY(Qt::LayoutDirection inputDirection READ inputDirection NOTIFY inputDirectionChanged) +/

public:
    final QTransform inputItemTransform() const;
    final void setInputItemTransform(ref const(QTransform) transform);

    final QRectF inputItemRectangle() const;
    final void setInputItemRectangle(ref const(QRectF) rect);

    // in window coordinates
    final QRectF cursorRectangle() const; // ### what if we have rotations for the item?
    final QRectF anchorRectangle() const; // ### ditto

    // keyboard geometry in window coords
    final QRectF keyboardRectangle() const;

    final QRectF inputItemClipRectangle() const;

    enum Action {
        Click,
        ContextMenu
    }
    /+ Q_ENUM(Action) +/

    final bool isVisible() const;
    final void setVisible(bool visible);

    final bool isAnimating() const;

    final QLocale locale() const;
    final /+ Qt:: +/qt.core.namespace.LayoutDirection inputDirection() const;

    static QVariant queryFocusObject(/+ Qt:: +/qt.core.namespace.InputMethodQuery query, QVariant argument); // ### Qt 6: QVariant by const-ref

public /+ Q_SLOTS +/:
    @QSlot final void show();
    @QSlot final void hide();

    @QSlot final void update(/+ Qt:: +/qt.core.namespace.InputMethodQueries queries);
    @QSlot final void reset();
    @QSlot final void commit();

    @QSlot final void invokeAction(Action a, int cursorPosition);

/+ Q_SIGNALS +/public:
    @QSignal final void cursorRectangleChanged();
    @QSignal final void anchorRectangleChanged();
    @QSignal final void keyboardRectangleChanged();
    @QSignal final void inputItemClipRectangleChanged();
    @QSignal final void visibleChanged();
    @QSignal final void animatingChanged();
    @QSignal final void localeChanged();
    @QSignal final void inputDirectionChanged(/+ Qt:: +/qt.core.namespace.LayoutDirection newDirection);

private:
    /+ friend class QGuiApplication; +/
    /+ friend class QGuiApplicationPrivate; +/
    /+ friend class QPlatformInputContext; +/
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

