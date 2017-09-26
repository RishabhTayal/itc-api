def login()
	
end

def request(method, url_or_path = nil, params = nil, headers = {}, &block)
	headers.merge!(csrf_tokens)
	headers['User-Agent'] = USER_AGENT

	# Before encoding the parameters, log them
	log_request(method, url_or_path, params)

	# form-encode the params only if there are params, and the block is not supplied.
	# this is so that certain requests can be made using the block for more control
	if method == :post && params && !block_given?
		params, headers = encode_params(params, headers)
	end

	response = send_request(method, url_or_path, params, headers, &block)

	log_response(method, url_or_path, response)

	return response
end