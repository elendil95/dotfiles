#--------------------
# MIT License

# Copyright (c) 2018 Avi Aryan

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#-----------------------

#Dependencies: tar, gzip, p7zip, bzip2
#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $(basename "$0") file"
    exit 1
fi

if [ -f "$1" ]; then
    case $1 in
        *.tar.xz)   tar -xvf "$1"                         ;;
        *.tar.bz2)  tar -jxvf "$1"                        ;;
        *.tar.gz)   tar -zxvf "$1"                        ;;
        *.bz2)      bunzip2 "$1"                          ;;
        *.dmg)      hdiutil mount "$1"                    ;;
        *.gz)       gunzip "$1"                           ;;
        *.tar)      tar -xvf "$1"                         ;;
        *.tbz2)     tar -jxvf "$1"                        ;;
        *.tgz)      tar -zxvf "$1"                        ;;
        *.zip)      unzip "$1"                            ;;
        *.pax)      cat "$1" | pax -r                     ;;
        *.pax.z)    uncompress "$1" --stdout | pax -r     ;;
        *.rar)      7z x "$1"                             ;;
        *.z)        uncompress "$1"                       ;;
        *.7z)       7z x "$1"                             ;;
        *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
else
    echo "'$1' is not a valid file"
fi
