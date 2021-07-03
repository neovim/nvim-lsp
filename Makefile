test:
	sh ./scripts/run_test.sh

lint:
	luacheck .
	selene --display-style=quiet .

.PHONY: test lint
