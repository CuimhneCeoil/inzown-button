# inzown-btn daemon for the Inzown device.
# Copyright (C) 2023  Claude N. Warren, Jr, https://inzown.com
# Copyright (C) 2017  Vilniaus Blokas UAB, https://blokas.io/pisound
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2 of the
# License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

BRANCH=$(shell git branch --show-current)
CURDIR:=$(shell pwd)
INZN_VERSION=$(shell EMAIL="$(MAINTAINER)" gbp dch --debian-branch=$(BRANCH) > /dev/null; head -1 $(CURDIR)/debian/changelog | cut -d'(' -f2 | cut -d')' -f1)

ARCH ?= arm64

ifeq ($(ARCH),armhf)
CROSS_COMPILE ?= /usr/bin/arm-linux-gnueabihf-
else ifeq ($(ARCH),arm64)
CROSS_COMPILE ?= /usr/bin/aarch64-linux-gnu-
endif

CC=$(CROSS_COMPILE)gcc
STRIP=$(CROSS_COMPILE)strip

BINDIR ?= $(DESTDIR)/usr/bin
ETCDIR ?= $(DESTDIR)/etc/inzown/button

all: inzown-btn timer-chart

inzown-btn: inzown-btn.c
	$(CC) inzown-btn.c -o inzown-btn 
	#$(STRIP) inzown-btn

timer-chart: timer-chart.c
	$(CC) timer-chart.c -o timer-chart
	$(STRIP) timer-chart
	
install: all 
	install -d $(BINDIR) $(ETCDIR)
	install inzown-btn $(BINDIR)/inzown-btn
	install timer-chart $(ETCDIR)/timer-chart

clean:
	rm -f inzown-btn timer-chart

debian/changelog:
	EMAIL=claude@cuimhneceoil.ie gbp dch --ignore-branch -S -c --git-author

PHONY += clean_pkg
clean-pkg: clean
	rm -f debian/changelog
	
PHONY += pkg
pkg: clean-pkg debian/changelog
	gbp buildpackage --git-debian-branch=main --git-ignore-new



#inzown-btn.deb: inzown-btn
#	@gzip --best -n ./debian/usr/share/doc/inzown-btn/changelog ./debian/usr/share/doc/inzown-btn/changelog.Debian ./debian/usr/share/man/man1/inzown-btn.1
#	@mkdir -p debian/usr/bin
#	@cp inzown-btn debian/usr/bin/
#	@mkdir -p debian/usr/local/etc
#	@cp inzown.conf debian/usr/local/etc/
#	@fakeroot dpkg --build debian
#	@mv debian.deb inzown-btn.deb
#	@gunzip `find . | grep gz` > /dev/null 2>&1

.PHONY: $(PHONY)
