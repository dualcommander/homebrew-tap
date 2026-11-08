.PHONY: check

check:
	brew style Casks/dualcommander.rb
	brew audit --cask dualcommander/tap/dualcommander
