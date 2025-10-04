.PHONY: test test-file

# Run all tests
test:
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "lua MiniTest.run()" \
		-c "quit"

# Run a specific test file
# Usage: make test-file FILE=tests/test_config.lua
test-file:
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "lua MiniTest.run_file('$(FILE)')" \
		-c "quit"
