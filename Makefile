.PHONY: all clean distclean

NODE_DIR := node_modules

# node binaries
NPM_BIN := $(NODE_DIR)/.bin
COFFEE_CC := $(NPM_BIN)/coffee
BROWSERIFY := $(NPM_BIN)/browserify
DEPS := $(COFFEE_CC)

# opts
COFFEE_OPTS := -bc --no-header

# target-specific build
CHROME_DIR := chrome
CHROME_BUNDLE_IN := $(patsubst %,$(CHROME_DIR)/%,replace.js replace-all.js)
CHROME_BUNDLE := $(CHROME_DIR)/bundle.js

# targets
COMMON_DIR := common
COFFEE_COMMON := $(wildcard $(COMMON_DIR)/*.coffee)
IN_COFFEE := $(wildcard $(CHROME_DIR)/*.coffee)
OUT_JS := $(patsubst %.coffee,%.js,$(IN_COFFEE)) \
	$(patsubst $(COMMON_DIR)/%.coffee,$(CHROME_DIR)/%.js,$(COFFEE_COMMON))

# recipes
all: $(CHROME_BUNDLE)

$(CHROME_BUNDLE): $(OUT_JS)
	$(BROWSERIFY) $(CHROME_BUNDLE_IN) > $@

%.js: %.coffee $(COFFEE_CC)
	$(COFFEE_CC) $(COFFEE_OPTS) $<

$(CHROME_DIR)/%.js: $(COMMON_DIR)/%.coffee $(COFFEE_CC)
	$(COFFEE_CC) $(COFFEE_OPTS) -o $(CHROME_DIR) $<

clean:
	rm -f $(OUT_JS)

distclean: clean
	rm -rf $(NODE_DIR)

$(DEPS):
	npm install
