path = require('path')
ptyjs = require('pty.js')
termjs = require('term.js')

module.exports =
class TermyView
  constructor: (filePath) ->
    @title = path.basename(filePath) + ' termy'
    @cwd = path.dirname(filePath)
    @pane = null

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('termy')

  init: ->
    return if @pty

    @pty = ptyjs.spawn(@getShell(), [],
      name: 'xterm-256color'
      cols: 80
      rows: 24
      cwd: @cwd
      env: process.env)

    @term = new termjs(
      name: 'xterm-256color'
      cols: 80,
      rows: 24
      screenKeys: true,
      useStyle: true
    )

    @pty.on('exit', @destroy.bind(@))
    @term.on('destroy', @destroy.bind(@))

    @term.on('data', @pty.write.bind(@pty))
    @term.open(@element)
    @pty.pipe(@term)

  # Tear down any state and detach
  destroy: ->
    @pty?.destroy()
    @term?.destroy()
    @element?.remove()
    @pane?.destroyItem(@)
    @pty = @term = @pane = undefined

  getElement: ->
    @element

  getTitle: ->
    @title

  getPane: ->
    @pane

  getShell: ->
    if process.platform is 'win32' then path.resolve(
      process.env.SystemRoot, 'WindowsPowerShell', 'v1.0', 'powershell.exe')
    else process.env.SHELL

  setPane: (pane) ->
    @pane = pane
    @init()
