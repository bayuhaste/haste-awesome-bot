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
      robot.messageRoom room, "I have a secret: #{secret}"
      msg =
        message:
          reply_to: "pull-requests"
          room: "pull-requests"
        content: "bitbucket-prs-post"
      robot.messageRoom room, "message:#{msg}"
    else
      res.reply "BitBucket is in #{status} status."

  robot.router.post '/habot/test-post', (req, res) ->
    room = "pull-requests"
    data = null
    #resp = req.body
    
    try
      data = JSON.parse req.body.payload
    catch err
      robot.emit 'error', err
    
    robot.messageRoom room, "```message:#{data}```"

    res.writeHead 204, { 'Content-Length': 0 }
    res.end()