# Copyright [2016] 
# @Email: x62en (at) users (dot) noreply (dot) github (dot) com
# @Author: Ben Mz

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

request = require 'request'

module.exports = class Livetoken

	# Define the apikey used by the server
	constructor: (@apikey) ->

	# Execute status request
	status: ({callback}) ->
		unless callback
			callback = @_default_callback

		@_interact
			action: 'status'
			params: { 'Client_ID': @apikey }
			callback: callback

	# Execute token request
	request: ({phone, email, callback}) ->
		params = { 'Client_ID': @apikey }
		if phone
			params.Phone = phone
		if email
			params.Email = phone

		unless callback
			callback = @_default_callback

		@_interact
			action: 'request'
			params: params
			callback: callback

	_default_callback: (raw) ->
		console.log JSON.stringify raw

	# Do the actual request to server (private call)
	_interact: ({action, params, callback}) ->
        request
            method: 'POST'
            json: true
            form: params
            uri: "https://livetoken.io/#{action}"
            (error, response, body) =>

                # Define answer object
                if not error and response.statusCode is 200
                	callback body
                else
                    callback {State: false, Msg: "Uknown server error: #{response.statusCode}"}
