.PHONY: all clean distclean

NODE_DIR := node_modules

# node binaries
NPM_BIN := $(NODE_DIR)/.bin
COFFEE_CC := $(NPM_BIN)/coffee
BROWSERIFY := $(NPM_BIN)/browserify
DEPS := $(COFFEE_CC)

# opts
COFFEE_OPTS := -bc --no-header

# target-specific stuff
CHROME_DIR := chrome
CHROME_BUNDLE_IN := $(patsubst %,$(CHROME_DIR)/%,replace.js replace-all.js)
CHROME_BUNDLE := $(CHROME_DIR)/bundle.js

FF_DIR := firefox
FF_BUNDLE_IN := $(patsubst %,$(FF_DIR)/%,replace-all.js)
FF_BUNDLE := $(FF_DIR)/bundle.js

# targets
COMMON_DIR := common
COFFEE_COMMON := $(wildcard $(COMMON_DIR)/*.coffee)
IN_COFFEE := $(wildcard $(CHROME_DIR)/*.coffee)
OUT_JS := $(patsubst %.coffee,%.js,$(IN_COFFEE))

# recipes
all: $(CHROME_BUNDLE) $(FF_BUNDLE) $(OUT_JS)

$(CHROME_BUNDLE): $(CHROME_BUNDLE_IN) $(BROWSERIFY)
	$(BROWSERIFY) $(CHROME_BUNDLE_IN) -o $@

$(FF_BUNDLE): $(FF_BUNDLE_IN) $(BROWSERIFY)
	$(BROWSERIFY) $(FF_BUNDLE_IN) -o $@

%.js: %.coffee $(COFFEE_CC)
	$(COFFEE_CC) $(COFFEE_OPTS) $<

$(CHROME_DIR)/%.js: $(COMMON_DIR)/%.coffee $(COFFEE_CC)
	$(COFFEE_CC) $(COFFEE_OPTS) -o $(CHROME_DIR) $<

$(FF_DIR)/%.js: $(COMMON_DIR)/%.coffee $(COFFEE_CC)
	$(COFFEE_CC) $(COFFEE_OPTS) -o $(FF_DIR) $<

clean:
	rm -f $(OUT_JS) $(CHROME_BUNDLE) $(FF_BUNDLE) $(CHROME_BUNDLE_IN) \
		$(FF_BUNDLE_IN)

distclean: clean
	rm -rf $(NODE_DIR)

$(DEPS):
	npm install
