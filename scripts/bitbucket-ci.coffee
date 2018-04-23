# Description:
#   Control CI helper from huhu slack.
#
# Notes:

module.exports = (robot) ->
  robot.respond /bitbucket (.*) status/i, (res) ->
    status = res.match[1]
    if status is "ready"
      secret = "data.secret"
      robot.messageRoom room, "I have a secret: #{secret}"
      #res.emit 'slack-attachment', msg
    else
      res.reply "BitBucket is in #{status} status."

  robot.router.post '/hubot/test-post', (req, res) ->
    resp = req.body
    
    msg =
        message:
          reply_to: "pull-requests"
          room: "pull-requests"
        content: "bitbucket-prs-post"

    robot.emit 'slack-attachment', msg

    res.writeHead 204, { 'Content-Length': 0 }
    res.end()