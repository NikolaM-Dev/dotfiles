.PHONY: install-extensions freeze-extensions

install-extensions:
	@echo "Installing extensions from extensions.txt..."
	@if [ -f extensions.txt ]; then \
		cat extensions.txt | xargs -L 1 code --install-extension; \
		echo "All extensions have been installed."; \
	else \
		echo "extensions.txt not found. Please run 'make freeze-extensions' first."; \
		exit 1; \
	fi

freeze-extensions:
	@echo "Listing installed extensions..."
	@code --list-extensions > extensions.txt
	@echo "Extensions have been listed in extensions.txt"
