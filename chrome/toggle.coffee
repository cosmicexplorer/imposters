SetupReplacements = require '../common/setup-replacements'

act = chrome.browserAction
doReplacement = no
replacements = null

act.onClicked.addListener (tab) ->
  if replacements?
    doReplacement = not doReplacement
    if doReplacement
      iconPath = 'res/imposter19.png'
    else
      iconPath = 'res/imposter19off.png'
    act.setIcon path: iconPath
    console.log "set imposters replacement to #{doReplacement}"

setup = ->
  act.setIcon path: 'res/imposter19off.png'
  replacements = null

success = (resp) ->
  if resp
    replacements = resp
    act.setIcon path: 'res/imposter19.png'
    doReplacement = yes

failure = (resp) ->
  if resp
    replacements = resp
    act.setIcon path: 'res/imposter19.png'
    doReplacement = yes

setupReplacements = -> SetupReplacements setup, success, failure

chrome.runtime.onMessage.addListener (req, sender, sendResponse) ->
  switch req
    when 'get-do-replacement' then sendResponse doReplacement
    when 'get-replacement-obj' then sendResponse replacements
    when 'setup-replacements'
      chrome.browsingData.removeCache {}, setupReplacements

setupReplacements()
