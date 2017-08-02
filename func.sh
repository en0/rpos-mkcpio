#!/usr/bin/env bash

## Copyright (c) 2017 "Ian Laird"
## Research Project Operating System (rpos) - https://github.com/en0/rpos
## 
## This file is part of rpos
## 
## rpos is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

_color_black="\e[30m"
_color_red="\e[31m"
_color_green="\e[32m"
_color_yellow="\e[33m"
_color_blue="\e[34m"
_color_magenta="\e[35m"
_color_cyan="\e[36m"
_color_lgray="\e[37m"
_color_reset="\e[39m"
_color_dgray="\e[90m"
_color_lred="\e[91m"
_color_lgreen="\e[92m"
_color_lyellow="\e[93m"
_color_lblue="\e[94m"
_color_lmagenta="\e[95m"
_color_lcyan="\e[96m"
_color_white="\e[97m"

func_init() {

    NAME=$1

    msgStep() {
        printf "${_color_green}==>${_color_reset} ${*}\n"
    }

    msgStepWarn() {
        printf "${_color_yellow}==>${_color_reset} ${*}\n"
    }

    msgStepError() {
        printf "${_color_red}==>${_color_reset} ${*}\n" >&2
    }

    msgInfo() {
        printf "${_color_blue}(${NAME}) ${_color_green}INFO:${_color_reset} ${*}\n"
    }

    msgError() {
        printf "${_color_blue}(${NAME}) ${_color_red}ERROR:${_color_reset} ${*}\n" >&2
    }

    msgWarn() {
        printf "${_color_blue}(${NAME}) ${_color_yellow}ERROR:${_color_reset} ${*}\n" >&2
    }

    abort() {
        msgError "$1"; exit 1
    }

    require() {
        which $1 >/dev/null
        if [ $? != 0 ]; then
            abort "Missing required software: $1"
        fi
    }

    require_env() {
        VAL=$(eval "echo \$$1")
        if [[ -z "$VAL" ]]; then
            abort "Missing required environment: $1"
        fi
    }

    prompt() {
        _ret=1
        read -r -p "$1 [y/n] " _resp
        case $_resp in
        [yY][eE][sS]|[yY])
            _ret=0
            ;;
        esac

        return $_ret
    }

    display_center(){

        text="$1"

        cols=`tput cols`

        _IFS=$IFS
        IFS=$'\n'$'\r'
        for line in $(echo -e $text); do

            line_length=`echo $line| wc -c`
            half_of_line_length=`expr $line_length / 2`
            center=`expr \( $cols / 2 \) - $half_of_line_length`

            spaces=""
            for ((i=0; i < $center; i++)) {
            spaces="$spaces "
            }

            echo "$spaces$line"

        done
        IFS=$_IFS

    }

    hr() {
        i=0
        while [ $i -lt $1 ]; do
            i=$[$i+1]
            echo -n "-"
        done
    }

    banner() {
        printf "${_color_blue}"
        display_center $(hr $[$(tput cols) / 2 ])
        printf "${_color_dgray}"
        display_center "+ $1 +"
        printf "${_color_blue}"
        display_center $(hr $[$(tput cols) / 2 ])
        printf "${_color_reset}\n"
    }
}
