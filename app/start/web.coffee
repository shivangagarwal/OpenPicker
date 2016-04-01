#includes
path = require('path')
express = require('express')
consolidate = require('consolidate')
morgan = require('morgan')
bodyParser = require('body-parser')
compression = require('compression')
fs = require('fs')
appconfig = require('../config/appconfig').appconfig

#web port
port = process.env.PORT || 5000


exports.startApis = (err, results) ->
	console.log "Starting Apis"
	if err
		throw "Failed to start: #{err}"
	app = express()
		.engine('html', consolidate.handlebars)
		.set('views', 'website/views')
		.set('view engine', 'ejs')
		.use(morgan('combined'))
    	.use(bodyParser.json())
    	.use(bodyParser.urlencoded({ extended: false }))
		.use(compression())

	#Api initialization
	console.log "Initializing apis at #{process.cwd()}"
	apiSubDirectories = ["web","script"]
	for apiSubDirectory in apiSubDirectories
		files = fs.readdirSync "./app/api/#{apiSubDirectory}"
		for file in files
			api = file.split('.')
			if ! api || ! api[0]
				continue
			require("../api/#{apiSubDirectory}/#{api[0]}").init(app)

		

	app.use(express.static(path.join(__dirname, '../../website/public')))
	app.use(express.static(appconfig.getUploadDirectory()))

	app.listen port, ->
		console.log("Listening on #{port}")
		
#console.log "Starting Web Server"
#startApis()
