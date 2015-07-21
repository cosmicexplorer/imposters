.PHONY: all clean distclean

NODE_DIR := node_modules

# node binaries
NPM_BIN := $(NODE_DIR)/.bin
COFFEE_CC := $(NPM_BIN)/coffee
DEPS := $(COFFEE_CC)

# opts
COFFEE_OPTS := -bc --no-header

# chrome build
CHROME_DIR := chrome

# targets
IN_COFFEE := $(wildcard $(CHROME_DIR)/*.coffee)
OUT_JS := $(patsubst %.coffee,%.js,$(IN_COFFEE))

# recipes
all: $(OUT_JS)

%.js: %.coffee $(COFFEE_CC)
	$(COFFEE_CC) $(COFFEE_OPTS) $<

clean:
	rm -f $(OUT_JS)

distclean: clean
	rm -rf $(NODE_DIR)

$(DEPS):
	npm install
