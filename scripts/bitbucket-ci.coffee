# Description:
#   Control CI helper from huhu slack.
#
# Notes:

module.exports = (robot) ->
  robot.respond /bitbucket (.*) status/i, (res) ->
    status = res.match[1]
    if status is "ready"
      res.reply "BitBucket is ready."
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
    res.reply "see pull-requests"

    res.writeHead 204, { 'Content-Length': 0 }
    res.end()