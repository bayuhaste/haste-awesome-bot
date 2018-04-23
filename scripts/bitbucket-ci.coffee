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
    typex = req.headers["X-Event-Key"]
    type = req.headers[1]

    try
      data = JSON.parse req.body.payload
    catch err
      robot.emit 'error', err
      
    resp = req.body

    # Really don't understand why this isn't in the response body
    # https://confluence.atlassian.com/bitbucket/event-payloads-740262817.html#EventPayloads-HTTPHeaders
    
    # type = 'x-event-key';

    # Slack special formatting
    # if robot.adapterName is 'slack'
    #   slack_adapter_obj = require('hubot-slack')
    # event = new SlackPullRequestEvent(robot, resp, type)

    # msg =
    #   message:
    #     reply_to: room
    #     room: room
    #   content: event.getMessage()
    robot.messageRoom room, "```Notification:#{typex} and #{type}```"

    # Close response
    res.writeHead 204, { 'Content-Length': 0 }
    res.end()