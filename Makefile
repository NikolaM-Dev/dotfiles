all:
	stow --verbose --target=$$HOME --restow */
	rm -rf $$HOME/.config/gtk
	rm -rf $$HOME/.config/nvim
	rm -rf $$HOME/.config/qtile
	rm -rf $$HOME/.xprofile


delete:
	stow --verbose --target=$$HOME  --delete */