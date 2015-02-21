Feature:
    Httpbin.org exposes various resources for HTTP request testing
    As Httpbin client I want to verify that all API resources are working as they should

    Scenario: Setting headers in GET request
        Given I set User-Agent header to apickli
        When I GET /get
		Then response body path $.headers.User-Agent should be apickli

	Scenario: Setting body payload in POST request
        Given I set body to {"key":"hello-world"}
        When I POST /post
        Then response body should contain hello-world

	Scenario: Sending request with basic auth authentication
		Given I have basic authentication credentials username and password
		When I POST /post
		Then response body should contain dXNlcm5hbWU6cGFzc3dvcmQ=

	Scenario: Parsing response xml body
		When I GET /xml
		Then response body path /slideshow/slide[1]/title should be Wake up to WonderWidgets!	

	Scenario: Checking headers in response
		When I GET /xml
		Then response header server should exist 
		And response header boo should not exist