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

ifndef PREFIX
	PREFIX="/usr"
endif

target_dir:=$(PREFIX)/share/mkcpio
target_sym:=$(PREFIX)/bin/mkcpio
#INST_OPTS=-g root -o root -m 440
INST_OPTS=

.PHONY : all install check-env clean

all : build.env check-env

install : func.sh mkcpio.sh build.env check-env
	@install $(INST_OPTS) -D -m 440 build.env $(target_dir)/build.env
	@echo "INSTALL - build.env"
	@install $(INST_OPTS) -D -m 440 func.sh $(target_dir)/func.sh
	@echo "INSTALL - func.sh"
	@install $(INST_OPTS) -D -m 550 mkcpio.sh $(target_dir)/mkcpio.sh
	@echo "INSTALL - mkcpio.sh"
	@unlink $(target_sym) 2>/dev/null | true
	@ln -s $(target_dir)/mkcpio.sh $(target_sym)
	@echo "LINK    - mkcpio"
	
build.env : FORCE
	@$(RM) build.env
	@echo "export SYSROOT=$(SYSROOT)" > build.env
	@echo "CREATE  - build.env"

check-env :
ifndef SYSROOT
	$(error SYSROOT undefined)
endif

FORCE:
