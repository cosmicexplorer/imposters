html2Arr = (htmlCollection) ->
  Array.prototype.slice.call htmlCollection, 0

inspectInvalidNode = (node) ->
  not node or
    node.tagName.toUpperCase() is 'input' or
    node.getAttribute? 'contenteditable' or
    node.getAttribute? 'role' is 'textbox'

isValidNode =
  (node) ->
    return no if node is document or node.parentNode is document
    while node.parentNode isnt document
      return no if inspectInvalidNode node
      node = node.parentNode
    yes

# wish i could just put a function into the json and eval it, but that's
# literally the most insecure thing ever to do in the world, so here's an
# attempt to make it less sucky
makeFunctionFromReplacementObject = (rplc, strictCaps) -> ->
  text = rplc.text
  for el, ind in arguments
    text = text.replace new RegExp("((\\$\\$)*)(\\$#{ind})", "g"), (res, g1) ->
      "#{g1}#{el}"
  if not strictCaps
    text
  else if arguments[0] is arguments[0].toUpperCase()
    text.toUpperCase()
  else if arguments[0][0] is arguments[0][0].toUpperCase()
    text.replace /\b./g, (match) -> match.toUpperCase()
  else
    text

replaceAllFromJson = (rplc, baseNode, nonRecursive) ->
  changeFns = rplc.map (el) -> (txt) ->
    regPat = el.pattern
    regPat = "\\b" + regPat + "\\b" if el.fullWord
    txt.replace new RegExp(regPat, "gi"),
      makeFunctionFromReplacementObject(el.replacement, el.strictCaps)
  if nonRecursive
    if isValidNode baseNode
      res = baseNode.data
      res = fn res for fn in changeFns
      baseNode.data = res unless baseNode.data is res
  else
    results = html2Arr((baseNode or document).getElementsByTagName '*')
    results = results.concat baseNode if baseNode and baseNode isnt document
    results = results.filter isValidNode
    results = results.map (node) -> html2Arr(node.childNodes).filter (child) ->
      child.nodeType is 3
    if results.length > 0
      results = results.reduce (a, b) -> a.concat b # flatten
      results.forEach (node) ->
        # have to check if result is different from prev before setting equal
        # chrome optimizes away the case in which they're equal, but ff doesn't
        # and causes infinite loop
        res = node.data
        res = fn res for fn in changeFns
        node.data = res unless node.data is res

watchNodesAndReplaceText = (rplc) ->
  return unless rplc
  replaceAllFn = -> replaceAllFromJson rplc
  replaceAllFn()
  # for dynamic pages like google instant
  setTimeout replaceAllFn, 500
  setTimeout replaceAllFn, 1000
  obsv = new MutationObserver (records) ->
    for rec in records
      switch rec.type
        when 'characterData' then replaceAllFromJson rplc, rec.target, yes
        when 'childList'
          replaceAllFromJson rplc, rec.target, no if rec.addedNodes.length > 0
  setTimeout (->
    replaceAllFn()
    obsv.observe document,
      childList: on
      subtree: on
      characterData: on),
    2000

module.exports =
  ReplaceAllFromJson: replaceAllFromJson
  WatchNodesAndReplaceText: watchNodesAndReplaceText
