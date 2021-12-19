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
module qt.gui.stylehints;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.namespace;
import qt.core.object;
import qt.core.qchar;
import qt.helpers;

extern(C++, class) struct QStyleHintsPrivate;

/// Binding for C++ class [QStyleHints](https://doc.qt.io/qt-5/qstylehints.html).
class /+ Q_GUI_EXPORT +/ QStyleHints : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QStyleHints) +/
    /+ Q_PROPERTY(int cursorFlashTime READ cursorFlashTime NOTIFY cursorFlashTimeChanged FINAL)
    Q_PROPERTY(qreal fontSmoothingGamma READ fontSmoothingGamma STORED false CONSTANT FINAL)
    Q_PROPERTY(int keyboardAutoRepeatRate READ keyboardAutoRepeatRate STORED false CONSTANT FINAL)
    Q_PROPERTY(int keyboardInputInterval READ keyboardInputInterval NOTIFY keyboardInputIntervalChanged FINAL)
    Q_PROPERTY(int mouseDoubleClickInterval READ mouseDoubleClickInterval NOTIFY mouseDoubleClickIntervalChanged FINAL)
    Q_PROPERTY(int mousePressAndHoldInterval READ mousePressAndHoldInterval NOTIFY mousePressAndHoldIntervalChanged FINAL)
    Q_PROPERTY(QChar passwordMaskCharacter READ passwordMaskCharacter STORED false CONSTANT FINAL)
    Q_PROPERTY(int passwordMaskDelay READ passwordMaskDelay STORED false CONSTANT FINAL)
    Q_PROPERTY(bool setFocusOnTouchRelease READ setFocusOnTouchRelease STORED false CONSTANT FINAL)
    Q_PROPERTY(bool showIsFullScreen READ showIsFullScreen STORED false CONSTANT FINAL)
    Q_PROPERTY(bool showIsMaximized READ showIsMaximized STORED false CONSTANT FINAL)
    Q_PROPERTY(bool showShortcutsInContextMenus READ showShortcutsInContextMenus WRITE setShowShortcutsInContextMenus NOTIFY showShortcutsInContextMenusChanged FINAL)
    Q_PROPERTY(int startDragDistance READ startDragDistance NOTIFY startDragDistanceChanged FINAL)
    Q_PROPERTY(int startDragTime READ startDragTime NOTIFY startDragTimeChanged FINAL)
    Q_PROPERTY(int startDragVelocity READ startDragVelocity STORED false CONSTANT FINAL)
    Q_PROPERTY(bool useRtlExtensions READ useRtlExtensions STORED false CONSTANT FINAL)
    Q_PROPERTY(Qt::TabFocusBehavior tabFocusBehavior READ tabFocusBehavior NOTIFY tabFocusBehaviorChanged FINAL)
    Q_PROPERTY(bool singleClickActivation READ singleClickActivation STORED false CONSTANT FINAL)
    Q_PROPERTY(bool useHoverEffects READ useHoverEffects WRITE setUseHoverEffects NOTIFY useHoverEffectsChanged FINAL)
    Q_PROPERTY(int wheelScrollLines READ wheelScrollLines NOTIFY wheelScrollLinesChanged FINAL)
    Q_PROPERTY(int mouseQuickSelectionThreshold READ mouseQuickSelectionThreshold WRITE setMouseQuickSelectionThreshold NOTIFY mouseQuickSelectionThresholdChanged FINAL)
    Q_PROPERTY(int mouseDoubleClickDistance READ mouseDoubleClickDistance STORED false CONSTANT FINAL)
    Q_PROPERTY(int touchDoubleTapDistance READ touchDoubleTapDistance STORED false CONSTANT FINAL) +/

public:
    final void setMouseDoubleClickInterval(int mouseDoubleClickInterval);
    final int mouseDoubleClickInterval() const;
    final int mouseDoubleClickDistance() const;
    final int touchDoubleTapDistance() const;
    final void setMousePressAndHoldInterval(int mousePressAndHoldInterval);
    final int mousePressAndHoldInterval() const;
    final void setStartDragDistance(int startDragDistance);
    final int startDragDistance() const;
    final void setStartDragTime(int startDragTime);
    final int startDragTime() const;
    final int startDragVelocity() const;
    final void setKeyboardInputInterval(int keyboardInputInterval);
    final int keyboardInputInterval() const;
    final int keyboardAutoRepeatRate() const;
    final void setCursorFlashTime(int cursorFlashTime);
    final int cursorFlashTime() const;
    final bool showIsFullScreen() const;
    final bool showIsMaximized() const;
    final bool showShortcutsInContextMenus() const;
    final void setShowShortcutsInContextMenus(bool showShortcutsInContextMenus);
    final int passwordMaskDelay() const;
    final QChar passwordMaskCharacter() const;
    final qreal fontSmoothingGamma() const;
    final bool useRtlExtensions() const;
    final bool setFocusOnTouchRelease() const;
    final /+ Qt:: +/qt.core.namespace.TabFocusBehavior tabFocusBehavior() const;
    final void setTabFocusBehavior(/+ Qt:: +/qt.core.namespace.TabFocusBehavior tabFocusBehavior);
    final bool singleClickActivation() const;
    final bool useHoverEffects() const;
    final void setUseHoverEffects(bool useHoverEffects);
    final int wheelScrollLines() const;
    final void setWheelScrollLines(int scrollLines);
    final void setMouseQuickSelectionThreshold(int threshold);
    final int mouseQuickSelectionThreshold() const;

/+ Q_SIGNALS +/public:
    @QSignal final void cursorFlashTimeChanged(int cursorFlashTime);
    @QSignal final void keyboardInputIntervalChanged(int keyboardInputInterval);
    @QSignal final void mouseDoubleClickIntervalChanged(int mouseDoubleClickInterval);
    @QSignal final void mousePressAndHoldIntervalChanged(int mousePressAndHoldInterval);
    @QSignal final void startDragDistanceChanged(int startDragDistance);
    @QSignal final void startDragTimeChanged(int startDragTime);
    @QSignal final void tabFocusBehaviorChanged(/+ Qt:: +/qt.core.namespace.TabFocusBehavior tabFocusBehavior);
    @QSignal final void useHoverEffectsChanged(bool useHoverEffects);
    @QSignal final void showShortcutsInContextMenusChanged(bool);
    @QSignal final void wheelScrollLinesChanged(int scrollLines);
    @QSignal final void mouseQuickSelectionThresholdChanged(int threshold);

private:
    /+ friend class QGuiApplication; +/
    this();
}

