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
