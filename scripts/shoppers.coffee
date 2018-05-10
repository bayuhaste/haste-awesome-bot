# Description:
#   Shopper-related scripts 
#
# Notes:

Postgres = require('pg')

module.exports = (robot) ->

  robot.respond /have some shoppers/i, (res) =>
    dotenv = require('dotenv').load()
    db_url = process.env.DATABASE_URL
    if !db_url?
      throw new Error('pg-brain requires a DATABASE_URL to be set.')
    
    client = new Postgres.Client(
      connectionString: db_url
      ssl: true)
    
    client.connect()

    client.on db_url, (notification) ->
      console.log "notification:#{notification.channel}"
      console.log notification

    client.on 'error', (err) ->
      console.log "client:error"
      console.log err

    client.query("SELECT * FROM tbl_customer_clusters ORDER BY customer_id DESC;", (err, result) ->
      for row in result.rows
        console.log(JSON.stringify(row))
        robot.messageRoom "pull-requests", "Customer: #{row.customer_id} Cluster: #{row.cluster_id}"
    )
    robot.brain.on 'close', ->
      client.end()

  robot.respond /get shopper (.*)/i, (res) =>
    customer_id = res.match[1]

    dotenv = require('dotenv').load()
    db_url = process.env.DATABASE_URL
    if !db_url?
      throw new Error('pg-brain requires a DATABASE_URL to be set.')
    
    client = new Postgres.Client(
      connectionString: db_url
      ssl: true)
    
    client.connect()

    client.query("SELECT * FROM tbl_customer_clusters WHERE customer_id=\'#{customer_id}\';", (err, result) ->
      message = ""
      if (result.rows.length > 0)
        for row in result.rows
          message += "Specific-customer: #{row.customer_id} in cluster: #{row.cluster_id}"
      else
        message += "No customer in  cluster #{customer_id}"
      robot.messageRoom "pull-requests", message
    )
    robot.brain.on 'close', ->
      client.end()

  robot.respond /get shoppers from cluster (.*)/i, (res) =>
    cluster_id = res.match[1]

    dotenv = require('dotenv').load()
    db_url = process.env.DATABASE_URL
    if !db_url?
      throw new Error('pg-brain requires a DATABASE_URL to be set.')
    
    client = new Postgres.Client(
      connectionString: db_url
      ssl: true)
    
    client.connect()

    client.query("SELECT * FROM tbl_customer_clusters WHERE cluster_id=\'#{cluster_id}\';", (err, result) ->
      message = ""
      if (result.rows.length > 0)
        message += "In cluster #{cluster_id}:\n"
        for row in result.rows
          message += "Customer: #{row.customer_id}\n"
      else
        message += "No customer in  cluster #{cluster_id}"
      console.log(message)
      robot.messageRoom "pull-requests", message
    )
    robot.brain.on 'close', ->
      client.end()