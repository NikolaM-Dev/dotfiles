IGNORED_CONFS=nvim, qtile

all:
	stow --verbose --target=$$HOME --ignore=$(IGNORED_CONFS) --restow */

delete:
	stow --verbose --target=$$HOME --ignore=$(IGNORED_CONFS) --delete */