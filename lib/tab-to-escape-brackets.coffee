{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null
  brackets: /]|\)|}/

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'tab-to-escape-brackets:escape': =>
        console.log("Entered tab-to-escape-brackets:escape")
        event.abortKeyBinding() unless @escapeBrackets()

  deactivate: ->
    @subscriptions.dispose()

  escapeBrackets: ->
    editor = atom.workspace.getActiveTextEditor()
    cursorPosition = editor.getCursorBufferPosition()
    searchRange = [cursorPosition, [cursorPosition.row, Infinity]]

    found = false
    editor.scanInBufferRange @brackets, searchRange, ({range, stop}) ->
      console.log("found")
      found = true
      position = range.end
      position = [position.row, position.column]
      editor.setCursorBufferPosition(position)
      stop()

    found
