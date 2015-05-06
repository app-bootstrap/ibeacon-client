git_version = $$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

all: test
install:
	@pod install --verbose --no-repo-update
pull:
	@git pull origin ${git_version}
push:
	@git push origin ${git_version}
.PHONY: test
