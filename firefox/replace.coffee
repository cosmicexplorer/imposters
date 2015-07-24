Replace = require '../common/replace-all'

self.port.emit 'get-do-replacement'

self.port.on 'get-do-replacement', (doReplacement) ->
  if doReplacement
    self.port.emit 'get-replacement-obj'
    self.port.on 'get-replacement-obj', Replace.WatchNodesAndReplaceText
