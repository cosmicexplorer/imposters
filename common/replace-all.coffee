# most of these will contain ONLY text without tags inside; however, <span> may
# contain further elements inside it, even though it's typically only used for
# text highlighting. oh well.
selectors = 'a,p,b,i,blockquote,q,span,div,li,h1,h2,h3,h4,h5,h6,title,strong,em'

html2Arr = (htmlCollection) ->
  Array.prototype.slice.call htmlCollection, 0

isValidNode =
  (node) ->
    while node.parentNode isnt document
      return no if node.getAttribute? 'contenteditable' or
        node.getAttribute? 'role' is 'textbox'
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
  if strictCaps and arguments[0][0] is arguments[0][0].toUpperCase()
    text.replace /\b./g, (match) -> match.toUpperCase()
  else
    text

replaceAllFromJson = (rplc, baseNode, nonRecursive) ->
  changeFns = rplc.map (el) -> (txt) ->
    txt.replace new RegExp(el.pattern, "gi"),
      makeFunctionFromReplacementObject(el.replacement, el.strictCaps)
  if nonRecursive
    if isValidNode baseNode
      res = baseNode.data
      res = fn res for fn in changeFns
      baseNode.data = res unless baseNode.data is res
  else
    results = html2Arr((baseNode or document).querySelectorAll selectors)
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
