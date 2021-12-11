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
module qt.config;

enum QT_STRINGVIEW_LEVEL = 1;

template defined(string name)
{
    enum defined = __traits(hasMember, qt.config, name);
}

template configValue(string name)
{
    static if(defined!name)
        mixin("enum configValue = " ~ name ~ ";");
    else
        enum configValue = 0;
}

template versionIsSet(string name)
{
    mixin((){
        string r;
        r ~= "version(" ~ name ~ ")\n";
        r ~= "enum versionIsSet = true;\n";
        r ~= "else\n";
        r ~= "enum versionIsSet = false;\n";
        return r;
        }());
}
