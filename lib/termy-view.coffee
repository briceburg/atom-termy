module.exports =
class TermyView
  constructor: (cwd) ->
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
    "aaaa"
