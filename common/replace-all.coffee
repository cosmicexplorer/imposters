ReplaceTextNodes = require 'replace-all-text-nodes'

# wish i could just put a function into the json and eval it, but that's
# literally the most insecure thing ever to do in the world, so here's an
# attempt to make it less bad
makeFunctionFromReplacementObject = (rplc, strictCaps) -> ->
  # arguments will be the arguments passed to a regex replace
  text = rplc.text
  for el, ind in arguments
    text = text.replace new RegExp("((\\$\\$)*)(\\$#{ind})", "g"), (res, g1) ->
      "#{g1}#{el}"
  if strictCaps # maintain capitalization of replacement text always
    text
  else if arguments[0] is arguments[0].toUpperCase() # all caps
    text.toUpperCase()
  else if arguments[0][0] is arguments[0][0].toUpperCase() # initial caps
    text.replace /(\s|^)(.)/g, (match, g1, g2) ->
      g1 + (if g1 isnt '\u2060' then g2.toUpperCase() else g2)
  else text

changeFromReplacementsArr = (rplc) ->
  changeFns = rplc.map (el) -> (txt) ->
    regPat = el.pattern
    regPat = "\\b" + regPat + "\\b" if el.fullWord
    txt.replace new RegExp(regPat, "gi"),
      makeFunctionFromReplacementObject(el.replacement, el.strictCaps)
  (text) ->
    if text then changeFns.forEach (fn) -> text = fn text
    text

watchNodesAndReplaceText = (rplc) ->
  return unless rplc
  obsv = ReplaceTextNodes.replaceAllInPage changeFromReplacementsArr(rplc),
    timeouts: [500,1000,2000]
    futureNodesToo: yes
  setTimeout (-> obsv.observe document,
      childList: on
      subtree: on
      characterData: on),
    2000

module.exports =
  watchNodesAndReplaceText: watchNodesAndReplaceText
