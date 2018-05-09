# Description:
#   Control CI helper from huhu slack.
#
# Notes:

module.exports = (robot) ->
  robot.respond /bitbucket (.*) status/i, (res) ->
    status = res.match[1]
    if status is "ready"
      secret = "data.secret"
      room = 'pull-requests'
      # robot.messageRoom room, "I have a secret: #{secret}"
      msg =
        message:
          reply_to: "requester-reply"
          room: "pull-requests"
        content: "bitbucket-prs-post"
      robot.messageRoom room, "message:#{msg.content},#{msg.message.reply_to}"
    else
      res.reply "BitBucket is in #{status} status."

  # robot.router.post '/habot/test-post', (req, res) ->
  #   room = "pull-requests"
  #   data = null
  #   #resp = req.body
    
  #   try
  #     data = JSON.parse req.body.payload
  #   catch err
  #     robot.emit 'error', err
    
  #   robot.messageRoom room, "```message:#{data}```"

  #   res.writeHead 204, { 'Content-Length': 0 }
  #   res.end()

  robot.router.post '/habot/bitbucket-custom-pr', (req, res) ->
    room = "pull-requests"
    data  = if req.body.payload? then JSON.parse req.body.payload else req.body
    dataReq = req.body

    # if req.headers['x-event-key'] is "pullrequest:created"
    robot.messageRoom room, "Pull request from `#{dataReq.actor.username}` has been created." #\n review in: #{dataReq.links.html}"
    
    res.send(dataReq.actor)
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()