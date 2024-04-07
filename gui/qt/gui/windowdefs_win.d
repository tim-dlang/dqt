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
alias HINSTANCE = HINSTANCE__*;
/+ Q_DECLARE_HANDLE(HINSTANCE); +/
/+ #endif
#ifndef HDC +/
struct HDC__;
alias HDC = HDC__*;
/+ Q_DECLARE_HANDLE(HDC); +/
/+ #endif
#ifndef HWND +/
struct HWND__;
alias HWND = HWND__*;
/+ Q_DECLARE_HANDLE(HWND); +/
/+ #endif
#ifndef HFONT +/
struct HFONT__;
alias HFONT = HFONT__*;
/+ Q_DECLARE_HANDLE(HFONT); +/
/+ #endif
#ifndef HPEN +/
struct HPEN__;
alias HPEN = HPEN__*;
/+ Q_DECLARE_HANDLE(HPEN); +/
/+ #endif
#ifndef HBRUSH +/
struct HBRUSH__;
alias HBRUSH = HBRUSH__*;
/+ Q_DECLARE_HANDLE(HBRUSH); +/
/+ #endif
#ifndef HBITMAP +/
struct HBITMAP__;
alias HBITMAP = HBITMAP__*;
/+ Q_DECLARE_HANDLE(HBITMAP); +/
/+ #endif
#ifndef HICON +/
struct HICON__;
alias HICON = HICON__*;
/+ Q_DECLARE_HANDLE(HICON); +/
/+ #endif
#ifndef HCURSOR +/
alias HCURSOR = HICON;
/+ #endif
#ifndef HPALETTE +/
struct HPALETTE__;
alias HPALETTE = HPALETTE__*;
/+ Q_DECLARE_HANDLE(HPALETTE); +/
/+ #endif
#ifndef HRGN +/
struct HRGN__;
alias HRGN = HRGN__*;
/+ Q_DECLARE_HANDLE(HRGN); +/
/+ #endif
#ifndef HMONITOR +/
struct HMONITOR__;
alias HMONITOR = HMONITOR__*;
/+ Q_DECLARE_HANDLE(HMONITOR); +/
/+ #endif
#ifndef _HRESULT_DEFINED +/
alias HRESULT = cpp_long;
/+ #endif +/

