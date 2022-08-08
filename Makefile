all:
	cp ./.stow-global-ignore $$HOME
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME  --delete */
