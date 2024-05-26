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
module qt.qml.jsnumbercoercion;
extern(C++):

import qt.config;
import qt.core.global;
import qt.helpers;

extern(C++, class) struct QJSNumberCoercion
{
public:
    static int toInteger(double d) {
        if (!equals(d, d))
            return 0;

        const(int) i = static_cast!(int)(d);
        if (equals(i, d))
            return i;

        return QJSNumberCoercion(d).toInteger();
    }

    static bool equals(double lhs, double rhs)
    {
        /+ QT_WARNING_PUSH
        QT_WARNING_DISABLE_FLOAT_COMPARE +/
        return lhs == rhs;
        /+ QT_WARNING_POP +/
    }

private:
    this(double dbl)
    {
        import core.stdc.string;

        // the dbl == 0 path is guaranteed constexpr. The other one may or may not be, depending
        // on whether and how the compiler inlines the memcpy.
        // In order to declare the ctor constexpr we need one guaranteed constexpr path.
        if (!equals(dbl, 0))
            memcpy(&d, &dbl, double.sizeof);
    }

    int sign() const
    {
        return (d >> 63) ? -1 : 1;
    }

    bool isDenormal() const
    {
        return static_cast!(int)((d << 1) >> 53) == 0;
    }

    int exponent() const
    {
        return static_cast!(int)((d << 1) >> 53) - 1023;
    }

    quint64 significant() const
    {
        quint64 m = (d << 12) >> 12;
        if (!isDenormal())
            m |= (static_cast!(quint64)(1) << 52);
        return m;
    }

    int toInteger()
    {
        int e = exponent() - 52;
        if (e < 0) {
            if (e <= -53)
                return 0;
            return sign() * static_cast!(int)(significant() >> -e);
        } else {
            if (e > 31)
                return 0;
            return sign() * (static_cast!(int)(significant()) << e);
        }
    }

    quint64 d = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

