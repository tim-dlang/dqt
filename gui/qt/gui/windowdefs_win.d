/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.gui.windowdefs_win;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.helpers;


/+ #if !defined(Q_NOWINSTRICT)
#define Q_WINSTRICT
#endif

#if defined(Q_WINSTRICT)

#if !defined(STRICT)
#define STRICT
#endif
#undef NO_STRICT
#define Q_DECLARE_HANDLE(name) struct name##__; typedef struct name##__ *name

#else

#if !defined(NO_STRICT)
#define NO_STRICT
#endif
#undef  STRICT
#define Q_DECLARE_HANDLE(name) typedef HANDLE name

#endif

#ifndef HINSTANCE +/
struct HINSTANCE__;
/+ Q_DECLARE_HANDLE(HINSTANCE) +/alias HINSTANCE = HINSTANCE__*;
/+ #endif
#ifndef HDC +/
struct HDC__;
/+ Q_DECLARE_HANDLE(HDC) +/alias HDC = HDC__*;
/+ #endif
#ifndef HWND +/
struct HWND__;
/+ Q_DECLARE_HANDLE(HWND) +/alias HWND = HWND__*;
/+ #endif
#ifndef HFONT +/
struct HFONT__;
/+ Q_DECLARE_HANDLE(HFONT) +/alias HFONT = HFONT__*;
/+ #endif
#ifndef HPEN +/
struct HPEN__;
/+ Q_DECLARE_HANDLE(HPEN) +/alias HPEN = HPEN__*;
/+ #endif
#ifndef HBRUSH +/
struct HBRUSH__;
/+ Q_DECLARE_HANDLE(HBRUSH) +/alias HBRUSH = HBRUSH__*;
/+ #endif
#ifndef HBITMAP +/
struct HBITMAP__;
/+ Q_DECLARE_HANDLE(HBITMAP) +/alias HBITMAP = HBITMAP__*;
/+ #endif
#ifndef HICON +/
struct HICON__;
/+ Q_DECLARE_HANDLE(HICON) +/alias HICON = HICON__*;
/+ #endif
#ifndef HCURSOR +/
alias HCURSOR = HICON;
/+ #endif
#ifndef HPALETTE +/
struct HPALETTE__;
/+ Q_DECLARE_HANDLE(HPALETTE) +/alias HPALETTE = HPALETTE__*;
/+ #endif
#ifndef HRGN +/
struct HRGN__;
/+ Q_DECLARE_HANDLE(HRGN) +/alias HRGN = HRGN__*;
/+ #endif
#ifndef HMONITOR +/
struct HMONITOR__;
/+ Q_DECLARE_HANDLE(HMONITOR) +/alias HMONITOR = HMONITOR__*;
/+ #endif
#ifndef _HRESULT_DEFINED +/
alias HRESULT = cpp_long;
/+ #endif +/

