TermyView = require './termy-view'
{CompositeDisposable} = require 'atom'

url = require('url')
HashMap = require('hashmap')

module.exports = Termy =
  subscriptions: null
  termyMap: new HashMap()

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'termy:open-right': => @open('right')
    @subscriptions.add atom.commands.add 'atom-workspace', 'termy:open-below': => @open('below')

    # register termy opener, respond to termy://<file>?location=<location> uris
    atom.workspace.addOpener @opener.bind(@)

  deactivate: ->
    @termyMap.forEach (value, key) ->
      value.destroy()
    @subscriptions.dispose()
    @emitter.dispose()


  open: (location) ->
    file = atom.workspace.getActivePaneItem()?.buffer?.file?.path
    return atom.workspace.open('termy://' + file + '?location=' + location) if file

  opener: (uri) ->
    return unless uri.match(/^termy:/)

    uri = url.parse(uri,true)

    termy = @termyMap.get(uri.pathname) || new TermyView(uri.pathname)
    @termyMap.set(uri.pathname, termy)

    pane = if uri.query.location is "right" then atom.workspace.getActivePane().splitRight() else
      atom.workspace.getActivePane().splitDown()

    termy.setPane(pane)
