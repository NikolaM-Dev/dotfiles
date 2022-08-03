all:
	stow --verbose --target=$$HOME --ignore=nvim --restow */

delete:
	stow --verbose --target=$$HOME --delete */