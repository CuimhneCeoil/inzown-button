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
LDFLAGS ?= -l/usr/arm-linux-gnueabihf/lib
else ifeq ($(ARCH),arm64)
CROSS_COMPILE ?= /usr/bin/aarch64-linux-gnu-
LDFLAGS ?= -l/usr/aarch64-linux-gnu/lib
endif

CC=$(CROSS_COMPILE)gcc
STRIP=$(CROSS_COMPILE)strip
LD=$(CROSS_COMPILE)/ld

BINDIR ?= $(DESTDIR)/usr/bin
ETCDIR ?= $(DESTDIR)/etc/inzown/button

all: inzown-btn timer-chart

inzown-btn: inzown-btn.c
	$(CC) inzown-btn.c -o inzown-btn --static
	$(STRIP) inzown-btn

timer-chart: timer-chart.c
	$(CC) timer-chart.c -o timer-chart --static
	$(STRIP) timer-chart
	
install: all 
	install -d $(BINDIR) $(ETCDIR)
	install inzown-btn $(BINDIR)/inzown-btn
	install timer-chart $(ETCDIR)/timer-chart

clean:
	rm -f inzown-btn timer-chart ../inzown-btn*
	
PHONY += pkg
pkg: clean
	EMAIL=claude@cuimhneceoil.ie gbp dch --ignore-branch -S -c --git-author
	#fakeroot -u debuild -Zgzip
	CROSS_COMPILE=$(CROSS_COMPILE) LDFLAGS=$(LDFLAGS)  dpkg-buildpackage -r"fakeroot -u" -aarm64 -i.git -us -uc -Zgzip

.PHONY: $(PHONY)
