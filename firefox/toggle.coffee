self = require 'sdk/self'
buttons = require 'sdk/ui/button/action'
tabs = require 'sdk/tabs'
xhr = require 'sdk/net/xhr'

SetupReplacements = require './setup-replacements'

doReplacement = no
replacements = null

handleClick = (btn) -> (state) ->
  if replacements?
    doReplacement = not doReplacement
    if doReplacement
      btn.icon = './imposter19.png'
    else
      btn.icon = './imposter19off.png'
    console.log "set imposters replacement to #{doReplacement}"

button = buttons.ActionButton
  id: "imposters-toggle"
  label: "Toggle your awareness of the world around you."
  icon: './imposter19off.png'

button.on "click", handleClick button

setup = ->
  button.icon = './imposter19off.png'
  replacements = null

success = (resp) ->
  if resp
    replacements = resp
    button.icon = './imposter19.png'
    doReplacement = yes

failure = (resp) ->
  if resp
    replacements = resp
    button.icon = './imposter19.png'
    doReplacement = yes

setupReplacements = -> SetupReplacements setup, success, failure, xhr

tabs.on 'ready', (tab) ->
  worker = tab.attach
    contentScriptFile: 'inject-bundle.js'
  worker.port.on 'get-do-replacement', ->
    worker.port.emit 'get-do-replacement', doReplacement
  worker.port.on 'get-replacement-obj', ->
    worker.port.emit 'get-replacement-obj', replacements
  worker.port.on 'setup-replacements', ->
    setupReplacements()

setupReplacements()
