# Copyright (c) 2023 terminus data science, LLC
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

VENV ?= .venv

ifeq ($(OS), Windows_NT)
	PYTHON ?= py -3.11
	VENV_PYTHON := $(VENV)/Scripts/python.exe
	RMDIR := cmd /c del /S /F /Q
else
	PYTHON ?= python3
	VENV_PYTHON = $(VENV)/bin/python
	RMDIR := rm -rf
endif

VENVCFG := $(VENV)/pyvenv.cfg

SOURCES := $(wildcard src/ihs29x/*)

define HELP
Available targets:
  General:
    make help: print this usage message

  Python development:
    make venv: create venv in .venv
    make repl: run Python REPL in venv
    make check: typecheck with mypy
    make package: package everything up for PyPI
    make publish-test: publish to test PyPI using token
    make publish: publish to PyPI using token
    make clean: remove venv and .venv directory
    make reinstall: reinstall package into venv, updating dependencies
endef

define REINSTALL
$(VENV_PYTHON) -m pip install -e .[dev,docs]
$(VENV_PYTHON) -m mypy --install-types --non-interactive .
endef

help:
	$(info $(HELP))
	@:

venv: $(VENVCFG)

repl: $(VENVCFG)
	$(VENV_PYTHON)

check: $(VENVCFG)
	$(VENV_PYTHON) -m mypy --strict src/ihs29x
	$(VENV_PYTHON) -m vulture src/ihs29x

package: $(VENVCFG)
	$(VENV_PYTHON) -m build

publish-test: $(VENVCFG) package
	$(VENV_PYTHON) -m twine upload --repository testpypi dist/* -u __token__

publish: $(VENVCFG) package
	$(VENV_PYTHON) -m twine upload dist/* -u __token__

docs: $(VENVCFG)
	$(VENV_PYTHON) -m pdoc -o docs ihs29x

clean:
	-$(RMDIR) .venv

$(VENVCFG): pyproject.toml
	$(PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install -U pip
	$(REINSTALL)

reinstall:
	$(REINSTALL)

.PHONY: help venv repl check package publish publish-test docs clean reinstall
