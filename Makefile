all: build
export EMACS ?= emacs
EMACSFLAGS = -L .
CASK = cask
VERSION = $(shell git describe --tags --abbrev=0 | sed 's/^v//')
PKG = fsharp-mode

elpa-$(EMACS):
	$(CASK) install
	$(CASK) update
	touch $@

elpa: elpa-$(EMACS)

build: elpa version
	$(CASK) build

version:
	$(EMACS) --version

test/Test1/restored:
	dotnet restore test/Test1
	touch test/Test1/restored

test: version build test/Test1/restored
	$(CASK) exec buttercup -L . -L ./test --traceback full

clean:
	rm -f .depend elpa-$(EMACS) $(OBJECTS) $(PKG)-autoloads.el

elpaclean: clean
	rm -f elpa*
	rm -rf .cask # Clean packages installed for development

run-$(PKG): elpa
	cask exec $(EMACS) -Q -L . --eval "(require '$(PKG))"
