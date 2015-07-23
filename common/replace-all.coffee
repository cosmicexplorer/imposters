# most of these will contain ONLY text without tags inside; however, <span> may
# contain further elements inside it, even though it's typically only used for
# text highlighting. oh well.
selectors = 'a, p, b, i, blockquote, q, span, div, li, h1, h2, h3, h4, h5, ' +
  'h6, title, strong, em'

html2Arr = (htmlCollection) ->
  Array.prototype.slice.call htmlCollection, 0

# wish i could just put a function into the json and eval it, but that's
# literally the most insecure thing ever to do in the world, so here's an
# attempt to make it less sucky
makeFunctionFromReplacementObject = (rplc, strictCaps, urls) -> ->
  text = rplc.text
  for el, ind in arguments
    text = text.replace new RegExp("((\\$\\$)*)(\\$#{ind})", "g"), (res, g1) ->
      "#{g1}#{el}"
  if strictCaps and arguments[0][0] is arguments[0][0].toUpperCase()
    text.replace /\b./g, (match) -> match.toUpperCase()
  else
    text

replaceAllFromJson = (rplc) ->
  results = html2Arr document.querySelectorAll selectors
  results = results.map (node) -> html2Arr(node.childNodes).filter (child) ->
    child.nodeType is 3
  if results.length > 0
    results = results.reduce (a, b) -> a.concat b # flatten
    changeFns = rplc.map (el) -> (txt) ->
      txt.replace new RegExp(el.pattern, "gi"),
        makeFunctionFromReplacementObject(el.replacement, el.strictCaps)
    results.forEach (node) ->
      node.data = fn node.data for fn in changeFns

module.exports = replaceAllFromJson
