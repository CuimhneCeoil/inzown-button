# Inzown Button

[![build_package](https://github.com/CuimhneCeoil/inzown-button/actions/workflows/build_package.yml/badge.svg)](https://github.com/CuimhneCeoil/inzown-button/actions/workflows/build_package.yml)

This project builds and packages the button for the [Inzown device](https://inzown.com).

The project is based on the [pisound button](http://blokas.io/pisound) code.  This package removes the check for pisound installation
and the default button effects.

# Installation

The default packaging for this project places the configurations in the `/etc/inzown/button` directory and the executable
as `/usr/bin/inzown-btn`.

The debian package installs an `inzown_button service` in SystemD.
