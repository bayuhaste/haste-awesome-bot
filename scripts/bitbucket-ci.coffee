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
    data  = if req.body.payload? then JSON.parse req.body.payload else req.body

    datax = JSON.stringify(data)
    # if datax? then res.send 'datax' else res.send 'error'

    # if datax['truncated']? then res.send "data0:#{datax['truncated']}" else res.send 'error'

    type = req.headers['x-event-key']
    if type? then res.send "type #{type}" else res.send 'type error'

    # datax1 = JSON.parse req.body.payload
    # datax2 = JSON.stringify({req.body})
  #   data = req.body
  #   commits = data.push.changes[0].commits
  #   author = commits[0].author.raw
  #   branch = data.push.changes[0].new.name
  #   msg = author + ' pushed ' + commits.length + ' commits to ' + data.repository.name + ':\n'
    # commit = null
    # i = 0
    # len = datax.length
    # while i < len
    #   commit = datax[i]
    #   msg += commit + '\n'
    #   i++
    # robot.messageRoom room, "```Notification: #{commit} \n```"
    # Close response
    res.send 'OK'
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()