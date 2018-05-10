# Description:
#   Shopper-related scripts 
#
# Notes:

Postgres = require('pg')

module.exports = (robot) ->

  robot.respond /get shoppers/i, (res) =>
    dotenv = require('dotenv').load()
    db_url = process.env.DATABASE_URL
    if !db_url?
      throw new Error('pg-brain requires a DATABASE_URL to be set.')
    
    client = new Postgres.Client(
      connectionString: db_url
      ssl: true)
    
    client.connect()
    client.on db_url, (notification) ->
      # write record to MongoDB or something
      console.log "notification:#{notification.channel}"
      console.log notification

    client.on 'error', (err) ->
      console.log "client:error"
      console.log err
    
    console.log "start of get shoppers"

    # result = client.query("SELECT storage FROM hubot LIMIT 1")
    # client.on "error", (err) ->
    #   robot.logger.error err

    # query = client.query('SELECT * FROM tbl_customer_clusters')
    # query.on 'row', (row, result) ->
    #   console.log(JSON.stringify(row))
    #   result.addRow row
    #   return

    client.query('SELECT * FROM tbl_customer_clusters;', (err, result) ->
      console.log "inside q res #{err}"
      for row in result.rows
        console.log(JSON.stringify(row))
        robot.messageRoom "pull-requests", "cluster-message: #{row.customer_id} in #{row.cluster_id}"
    )
    robot.brain.on 'close', ->
      client.end()

    console.log "end of get shoppers"
    # robot.messageRoom "pull-requests", "cluster-message: empty"