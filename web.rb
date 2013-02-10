require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

account_sid = 'AC66e1fa8cc8e5de5fdbccd6ce88eeb615'
auth_token = '9854d937fb8e47428081aca62aeb1d6d'
from_phone = '+19175255098'
to_phone = '+19172091905'
 
get '/' do
    @log = params[:log]
    @log = '' if @log.nil?
    '<html><body>' +
    '<h1>Twilio Demo</h1>' +
    'Running Twilio v' + Twilio::VERSION + '<br><br>' +
    '<span style="color:green">' + @log + '</span><br><br>' +
    '<form name="call" method="GET" action="/call">' +
	    'Call with a robot message<br>' +
	    '<textarea name="message" rows=10 cols=50>Hello, this is a test message from a robot.</textarea><br>' +
	    '<input type="submit">' +
    '</form><br><br>' +
    '<form name="call" method="GET" action="/sms">' +
	    'Text with a message<br>' +
	    '<textarea name="message" rows=10 cols=50>Hello, this is a text from a robot.</textarea><br>' +
	    '<input type="submit">' +
    '</form>' +

    '</body></html>' 
end

get '/call' do
	@message = params[:message]
	@message = @message.gsub(" ", "+")
	@client = Twilio::REST::Client.new account_sid, auth_token
	@call = @client.account.calls.create(
	  :from => from_phone,   # From your Twilio number
	  :to => to_phone,     # To any number
	  :url => 'http://twimlets.com/echo?Twiml=%3CResponse%3E%3CSay%3E' + @message + '%3C%2FSay%3E%3C%2FResponse%3E'   # Fetch instructions from this URL when the call connects
	)
	redirect '/?log=Call_Successful'
end

get '/sms' do
	@message = params[:message]
	@client = Twilio::REST::Client.new account_sid, auth_token
	@client.account.sms.messages.create(
    		:from => from_phone,
    		:to => to_phone,
    		:body => @message
  	) 
	redirect '/?log=SMS_Successful'
end