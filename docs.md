Adding Replacements
===================

The hope is that this extension will be able to avoid upgrades, possibly forever, simply pulling the latest version of replacements from this repo on every startup. Because of this, an expressive format is required for replacements.

# Replacement Objects

[Replacements](replacements.json) are an array of `replacement` objects. Each `replacement` object consists of two or three entries: `pattern`, `replacement`, and `strictCaps`.

## Fields

### pattern

`pattern` is a string which is converted to a regular expression. The `i` (ignore-caps) flag is used when reading the `pattern` expression, so don't worry about correct capitalization for the `pattern` field.

### replacement

`replacement` is an object which contains a `text` field, which is inserted as the replacement for the `pattern` text. The reason it is an object instead of a string is so that more functionality may be added in later versions, such as external urls and other such fun things. The replacement text is inserted literally, with one exception: expressions in the form `$x`, where `x` is a number from 1-9, will be replaced by the matching subexpression in `pattern`. `$$` is ignored, however, so ensure you line up the correct number of `$` characters. You can have multiple instances of the same subexpression in the `text` field.

### strictCaps

If `strictCaps` is set to `false` or undefined, when the first letter of the match is capitalized, all words in the replacement text have their first letter capitalized. If true, the capitalization of the replacement text is always exactly what is given in `replacements.json`.
