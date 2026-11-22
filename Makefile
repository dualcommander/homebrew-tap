.PHONY: check ci-check

check:
	brew style Casks/dualcommander.rb
	brew audit --cask dualcommander/tap/dualcommander

ci-check:
	brew tap dualcommander/tap
	cp Casks/dualcommander.rb "$$(brew --repository dualcommander/tap)/Casks/dualcommander.rb"
	$(MAKE) check
