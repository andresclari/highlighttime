# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class StreamManager
  currentStream: 0

  createStream: ->
    $.post '/streams.json', (data) =>
      @currentStream = data.id
      $('#start-stream-btn').hide()
      $('#stop-stream-btn').show()
      $('#create-highlight-btn').show()

  removeStream: (id, el) ->
    $.ajax
      url: '/streams/'+id+'.json'
      type: 'DELETE'
      success: (data) =>
        el.remove()

  finishStream: ->
    $.ajax
      url: '/streams/'+@currentStream+'.json'
      type: 'PATCH'
      success: (data) ->
        $('#highlights-table').empty()
        $('#create-highlight-btn').hide()
        $('#stop-stream-btn').hide()
        $('#start-stream-btn').show()

  createHighlight: ->
    $.ajax
      type: "POST"
      url: '/highlights.json'
      data:
        'highlight[stream_id]': @currentStream
      dataType: 'json'
      success: (data) =>
        start_time =  data.start_time
        button = '<button class="remove-highlight-btn btn btn-danger btn-sm" type="button">Remove</button>'
        hEl = $('<tr><td>'+start_time+'</td><td>'+button+'</td></tr>')
        $('#highlights-table').append hEl

  getHighlights: (id, callback) ->
    $.getJSON '/highlights.json?stream_id='+id, (data) => callback(data)

  deleteHighlight: (id, el) ->
    $.ajax
      url: '/highlights/'+id+'.json'
      type: 'DELETE'
      success: (data) =>
        el.remove()

$ ->
  manager = new StreamManager

  # If logged out, hook the progress dialog to the Twitter button
  if $('#twitter-login-btn').length > 0
    $('#twitter-login-btn').on 'click', ->
      $('#progress-dialog').modal
        'backdrop': 'static'
        'show'


  $('#start-stream-btn').on 'click', -> manager.createStream()
  $('#stop-stream-btn').on 'click', -> manager.finishStream()
  $('#create-highlight-btn').on 'click', -> manager.createHighlight()

  # Handle stream actions
  $('.view-stream-btn').on 'click', ->
    streamId = $($(this).parent().children()[0]).val()
    manager.getHighlights streamId, (data) ->
      $('.highlights-content #highlights-table').empty()

      for highlight in data
        start_time =  highlight.start_time
        hiddenId = '<input class="highlight-id" type="hidden" value="'+highlight.id+'"" />'
        button = '<button class="remove-highlight-btn btn btn-danger btn-sm" type="button">Remove'+hiddenId+'</button>'
        hEl = $('<tr><td>'+start_time+'</td><td>'+button+'</td></tr>')
        $('.highlights-content #highlights-table').append hEl

      $('#highlights-dialog .remove-highlight-btn').on 'click', ->
        highlightId = $($(this).children()[0]).val()
        row = $(this).parent().parent()
        manager.deleteHighlight highlightId, row

      $('#highlights-dialog').modal 'show'

  $('#highlights-dialog .highlights-dialog-ok-btn').on 'click', ->
    $('#highlights-dialog').modal 'hide'

  $('.remove-stream-btn').on 'click', ->
    streamId = $($(this).parent().children()[0]).val()
    row = $(this).parent().parent()
    manager.removeStream streamId, row
