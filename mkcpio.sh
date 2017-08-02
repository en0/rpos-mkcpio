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

[[ -e build.env ]] && source build.env
source func.sh

func_init "mkcpio"
require "cpio"
require "wc"
require "readlink"

usage() {
    printf "${_color_red}Usage:${_color_reset} %s" $(basename $0)
    printf " [${_color_red}-c ${_color_green}config${_color_reset}]"
    printf " [${_color_red}-o ${_color_green}outfile${_color_reset}]"
    printf " [${_color_red}-r ${_color_green}root${_color_reset}]\n"
    printf "\n"
    printf "Create a CPIO filesystem and install it as the rootfs.\n"
    printf "\n"
    printf "${_color_red}Options:${_color_reset}\n"
    printf " ${_color_red}-c ${_color_green}config${_color_reset} "
    printf " : Specify an alternate configuration file.\n"
    printf "              Default: /etc/mkcpio.conf\n\n"
    printf " ${_color_red}-o ${_color_green}outfile${_color_reset}"
    printf " : Write the image to outfile.\n"
    printf "              Default: /boot/initfs.cpio\n\n"
    printf " ${_color_red}-r ${_color_green}root${_color_reset}   "
    printf " : Change the SYSROOT used when searching for files.\n"
    printf "              Default: $SYSROOT\n\n"
}

while getopts ":c:o:r:h" opt; do
    case $opt in
    c) 
        _cpio_conf="${OPTARG}" 
        ;;
    o) 
        _cpio_out="${OPTARG}" 
        ;;
    r)
        _cpio_root="${OPTARG}"
        ;;
    h) 
        usage
        exit;
        ;;
    :) 
        usage
        abort "Option -$OPTARG requires an argument. see -h for details."
        exit 1;
        ;;
    \?) 
        usage
        abort "Invalid option: -$OPTARG"
        ;;
    esac
done

## Fill args
if [[ -z "${_cpio_root}" ]]; then
    require_env "SYSROOT"
    _cpio_root="${SYSROOT}"
fi

if [[ -z "${_cpio_conf}" ]]; then
    _cpio_conf="${_cpio_root}/etc/mkcpio.conf"
fi

if [[ -z "${_cpio_out}" ]]; then
    _cpio_out="${_cpio_root}/boot/initfs.cpio"
fi

## Validate args
if [[ ! -d "${_cpio_root}" ]]; then
    abort "Unable to use root: ${_cpio_root}"
fi

if [[ ! -e "${_cpio_conf}" ]]; then
    abort "Unable to use config: ${_cpio_conf}"
fi

_cpio_root=$(readlink -f ${_cpio_root})
_cpio_conf=$(readlink -f ${_cpio_conf})

_all_files=""

msgInfo Building CPIO Image using $_cpio_conf
source $_cpio_conf

if [[ ! -z "$FILES" ]]; then 
    for new_file in $FILES; do
        _full_name="${_cpio_root}${new_file}"
        if [[ -e $_full_name ]]; then
            msgStep Adding file: $_full_name
            _all_files="${_all_files} .${new_file}"
        else
            msgStepError File not found: ${_full_name}
        fi
    done
fi

if [[ -z "$(echo ${_all_files} | xargs)" ]]; then
    abort "There are no files to add to the CPIO archive. Nothing to do."
fi

if [[ ! -d $(dirname $_cpio_out) ]]; then
    msgStepWarn "Creating output path: $(dirname $_cpio_out)"
    mkdir -p $(dirname $_cpio_out)
fi

if [[ -e ${_cpio_out} ]]; then
    msgStepWarn "A cpio image already exists. Would you like to overrite?"
    prompt "Would you like to overwrite the file?"
    if [ $? != 0 ]; then
        abort "Operation aborted!"
    else
        rm -rf ${_cpio_out}
    fi
fi

msgStep Building output: $_cpio_out

set -o pipefail
_cpio_result=$( { cd ${_cpio_root}; echo -n ${_all_files} | xargs -n1 | cpio -o > ${_cpio_out}; } 2>&1)

if [ $? != 0 ]; then
    msgError Unable to create CPIO image: $_cpio_result
else
    msgInfo CPIO image created: $_cpio_result
fi

