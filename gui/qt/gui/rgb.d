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
module qt.gui.rgb;
extern(C++):

import qt.config;
import qt.helpers;

alias QRgb = uint;                        // RGB triplet

// non-namespaced Qt global variable
/+ Q_DECL_UNUSED +/ __gshared const(QRgb)  RGB_MASK    = 0x00ffffff;     // masks RGB values

pragma(inline, true) int qRed(QRgb rgb)                // get red part of RGB
{ return ((rgb >> 16) & 0xff); }

pragma(inline, true) int qGreen(QRgb rgb)                // get green part of RGB
{ return ((rgb >> 8) & 0xff); }

pragma(inline, true) int qBlue(QRgb rgb)                // get blue part of RGB
{ return (rgb & 0xff); }

pragma(inline, true) int qAlpha(QRgb rgb)                // get alpha part of RGBA
{ return rgb >> 24; }

pragma(inline, true) QRgb qRgb(int r, int g, int b)// set RGB value
{ return (0xffu << 24) | ((r & 0xffu) << 16) | ((g & 0xffu) << 8) | (b & 0xffu); }

pragma(inline, true) QRgb qRgba(int r, int g, int b, int a)// set RGBA value
{ return ((a & 0xffu) << 24) | ((r & 0xffu) << 16) | ((g & 0xffu) << 8) | (b & 0xffu); }

pragma(inline, true) int qGray(int r, int g, int b)// convert R,G,B to gray 0..255
{ return (r*11+g*16+b*5)/32; }

pragma(inline, true) int qGray(QRgb rgb)                // convert RGB to gray 0..255
{ return qGray(qRed(rgb), qGreen(rgb), qBlue(rgb)); }

pragma(inline, true) bool qIsGray(QRgb rgb)
{ return qRed(rgb) == qGreen(rgb) && qRed(rgb) == qBlue(rgb); }

pragma(inline, true) QRgb qPremultiply(QRgb x)
{
    const(uint) a = qAlpha(x);
    uint t = (x & 0xff00ff) * a;
    t = (t + ((t >> 8) & 0xff00ff) + 0x800080) >> 8;
    t &= 0xff00ff;

    x = ((x >> 8) & 0xff) * a;
    x = (x + ((x >> 8) & 0xff) + 0x80);
    x &= 0xff00;
    return x | t | (a << 24);
}

mixin(mangleWindows("?qt_inv_premul_factor@@3QBIB", q{
/+ Q_GUI_EXPORT +/ extern export __gshared const(uint)[0] qt_inv_premul_factor;
    }));

pragma(inline, true) QRgb qUnpremultiply(QRgb p)
{
    const(uint) alpha = qAlpha(p);
    // Alpha 255 and 0 are the two most common values, which makes them beneficial to short-cut.
    if (alpha == 255)
        return p;
    if (alpha == 0)
        return 0;
    // (p*(0x00ff00ff/alpha)) >> 16 == (p*255)/alpha for all p and alpha <= 256.
    const(uint) invAlpha = qt_inv_premul_factor. ptr[alpha];
    // We add 0x8000 to get even rounding. The rounding also ensures that qPremultiply(qUnpremultiply(p)) == p for all p.
    return qRgba((qRed(p)*invAlpha + 0x8000)>>16, (qGreen(p)*invAlpha + 0x8000)>>16, (qBlue(p)*invAlpha + 0x8000)>>16, alpha);
}

