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

  robot.router.post '/habot/bitbucket-custom-pr', (req, res) ->
    # Fallback to default Pull request room
    room = "pull-requests"
    data = null
    try
      data = JSON.parse req.body.payload
    catch err
      robot.emit 'error', err
    datax1 = JSON.stringify(req.body.payload)
    # datax2 = JSON.stringify({req.body})
  #   data = req.body
  #   commits = data.push.changes[0].commits
  #   author = commits[0].author.raw
  #   branch = data.push.changes[0].new.name
  #   msg = author + ' pushed ' + commits.length + ' commits to ' + data.repository.name + ':\n'
  #   i = 0
  #   len = commits.length
  #   while i < len
  #     commit = commits[i]
  # msg += commit.links.html.href + '\n' + '[' + branch + '] ' + commit.message + '\n'
  # i++
    robot.messageRoom room, "```Notification: #{datax1} \n```"
    # Close response
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()