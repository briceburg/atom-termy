TermyView = require './termy-view'
{CompositeDisposable} = require 'atom'

path = require('path')
url = require('url')

module.exports = Termy =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'termy:open-right': => @open('right')
    @subscriptions.add atom.commands.add 'atom-workspace', 'termy:open-below': => @open('below')

    # register termy opener, respond to termy://<file>?location=<location> uris
    atom.workspace.addOpener @opener

  deactivate: ->
    @subscriptions.dispose()
    @termyView.destroy()

  open: (location) ->
    file = atom.workspace.getActivePaneItem()?.buffer.file?.path
    return atom.workspace.open('termy://' + file + '?location=' + location) if file
    console.log('termy :: unable to determine filePath')

  opener: (uri) ->
    return unless uri.match(/^termy:/)

    uri = url.parse(uri,true)
    cwd = path.dirname(uri.pathname)

    termy = new TermyView(cwd)

    #console.log(atom.workspace.getActivePaneItem())
    atom.workspace.getActivePane().splitRight({items: [termy]})

    ###

    switch uri.query.location
      when "right" then atom.workspace.addRightPanel(item: termy.getElement())
      else atom.workspace.addBottomPanel(item: termy.getElement())
    ###

    # refuse to open a new editor...
    false
