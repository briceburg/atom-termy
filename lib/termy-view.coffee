path = require('path')

module.exports =
class TermyView
  constructor: (filePath) ->
    @title = path.basename(filePath) + ' termy'
    @cwd = path.dirname(filePath)
    @pane = null

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('termy')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The MyPackage package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  getTitle: ->
    @title

  getPane: ->
    @pane

  setPane: (pane) ->
    @pane = pane
