# apickli - REST API integration testing framework with cucumber.js

![NPM version](https://badge.fury.io/js/apickli.svg)

[![NPM](https://nodei.co/npm/apickli.png)](https://nodei.co/npm/apickli/)

**Apickli** is a REST API integration testing framework based on cucumber.js.

It provides a gherkin framework and a collection of utility functions to make API testing easy and less time consuming.

**Apickli** is also available as an [NPM package](https://www.npmjs.com/package/apickli).

[Cucumber.js](https://github.com/cucumber/cucumber-js) is JavaScript & Node.js implementation of Behaviour Driven Development test framework - [Cucumber](http://cukes.info/). Cucumber.js is using [Gherkin](http://cukes.info/gherkin.html) language for describing the test scenarios in [BDD](http://en.wikipedia.org/wiki/Behavior-driven_development) manner.  

## How to start - a simple tutorial

**Apickli** depends on cucumber.js being installed on your system. You can do this by installing cucumber.js globally:

```sh
$ npm install -g cucumber
```

### Copy example project

You can copy existing [example-project](example-project) directory in this code repository which has skeleton test project created with tests against `httpbin.org`

### Start new project

Below steps will help you start a new test project from scratch.

#### 1. Folder structure
Let's start a new integration testing project for an API called *myapi*. The folder structure will need to match the structure expected by cucumber.js:

    test/
    ---- features/
    --------- myapi.feature
    --------- step_definitions/
    -------------- myapi.js
    ---- package.json
    
Features directory contains cucumber feature files written in gherkin syntax. step_definitions contains the JavaScript implementation of gherkin test cases. Check out the GitHub repository for example implementations covering most used testing scenarios.

#### 2. Package.json
This can be an example package.json file for our project:

```json
{
	"name": "myapi-test",
	"version": "1.0.0",
	"description": "Integration testing for myapi v1",
	"dependencies": {
		"apickli": "latest"
	}
}
```

#### 3. Install dependencies
Now we can get the project dependencies installed: 

```sh
$ npm install
```
    
#### 4. Scenario definitions
We can now start defining our scenarios for the test. For this tutorial, we will be borrowing sections from the [example project](example-project/) in apickli source code. 

Let's start with the scenario file called *myapi.feature*. Full scenario definition with various other functions can be found here: [example-project/features/httpbin.feature](example-project/features/httpbin.feature)

```
Feature:
	Httpbin.org exposes various resources for HTTP request testing
	As Httpbin client I want to verify that all API resources are working as they should

	Scenario: Setting headers in GET request
		Given I set User-Agent header to apickli
		When I GET /get
		Then response body path $.headers.User-Agent should be apickli
```

#### 5. Get apickli-gherkin steps
We now need the corresponding step definitions that implement the steps in our scenario. Apickli has a collection of steps already implemented - ready to be included in your project: [source/apickli/apickli-gherkin.js](source/apickli/apickli-gherkin.js). It is included in the NPM package so you can symlink to it from under your local node_modules/apickli folder - see [example-project/features/step_definitions/apickli-gherkin.js](example-project/features/step_definitions/apickli-gherkin.js) for symlink. 

Refer to [Gherkin Expressions](#gherkin-expressions) section below to see a list of steps implemented by apickli-gherkin.

#### 6. Step_definitions for this project
Now we need a step definition file specific for this project, let's call it *myapi.js*:

```js
/* jslint node: true */
'use strict';

var apickli = require('apickli');

module.exports = function() {
	// cleanup before every scenario
	this.Before(function(scenario, callback) {
		this.apickli = new apickli.Apickli('http', 'httpbin.org');
		callback();
	});
};
```

#### 7. Run tests with cucumber.js
The following will run our scenario (in the project directory):

```sh
$ cucumber-js features/httpbin.feature
....

1 scenario (1 passed)
3 steps (3 passed)
```
	
## Grunt integration
    
You can also use [Grunt](http://gruntjs.com/) task runner to run the tests. 

### 1. Start by adding a Gruntfile.js to the project root:

```js
'use strict';

module.exports = function(grunt) {
	grunt.initConfig({
		cucumberjs: {
			src: 'features',
			options: {
				format: 'pretty',
				steps: 'features/step_definitions'
			}
		}
	});

	grunt.loadNpmTasks('grunt-cucumber');
	grunt.registerTask('tests', ['cucumberjs']);
}
```

### 2. Add grunt and grunt-cucumber dependencies to package.json:

```json
	...
	"dependencies": {
		"apickli": "latest",
		"grunt": "latest",
		"grunt-cucumber": "latest"
	}
	...
```

### 3. Install the new dependencies:

```sh
npm install
```

### 4. Now you can run the same tests using grunt:

```sh
$ grunt tests
Running "cucumberjs:src" (cucumberjs) task

Feature:
  Httpbin.org exposes various resources for HTTP request testing
  As Httpbin client I want to verify that all API resources are working as they should


  Scenario: Setting headers in GET request                         # features/httpbin.feature:5
    Given I set User-Agent header to apickli                       # features/httpbin.feature:6
    When I GET /get                                                # features/httpbin.feature:7
    Then response body path $.headers.User-Agent should be apickli # features/httpbin.feature:8


1 scenario (1 passed)
3 steps (3 passed)

Done, without errors.
``` 
## Gulp Integration
You can also use [Gulp](http://gulpjs.com/) to run the tests.

### 1. Start by adding a Gulpfile.js to the project root:

```js
var gulp = require('gulp');
var cucumber = require('gulp-cucumber');
 
gulp.task('test', function() {
    return gulp.src('features/*')
			.pipe(cucumber({
				'steps': 'features/step_definitions/*.js',
				'format': 'pretty'
			}));
});
```
### 2. Add gulp and gulp-cucumber dependencies to package.json:

```json
...
	"gulp": "latest",
	"gulp-cucumber": "latest"
...
```
### 3. Install local dependencies

```sh
$ npm install
```

### 4. Install gulp globally

```sh
$ npm install -g gulp
```

See [https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md).

### 5. Run tests using gulp
```sh
$ gulp test
``` 

## Gherkin Expressions
The following gherkin expressions are implemented in apickli source code [source/apickli/apickli-gherkin.js](source/apickli/apickli-gherkin.js):

```
GIVEN:
	I set (.*) header to (.*)
	I set body to (.*)
	I pipe contents of file (.*) to body
	I have basic authentication credentials (.*) and (.*)
	I set bearer token
	
WHEN:
	I GET $resource
	I POST to $resource
	I PUT $resource
	I DELETE $resource
	
THEN:
	response header (.*) should exist
	response header (.*) should not exist
	response body should be valid (xml|json)
	response code should be (\d+)
	response code should not be (\d+)
	response header (.*) should be (.*)
	response header (.*) should not be (.*)
	response body should contain (.*)
	response body should not contain (.*)
	response body path (.*) should be (.*)
	response body path (.*) should not be (.*)
	I store the value of body path (.*) as access token
	I store the value of response header (.*) as (.*) in scenario scope
	I store the value of body path (.*) as (.*) in scenario scope
	value of scenario variable (.*) should be (.*)
	I store the value of response header (.*) as (.*) in global scope
	I store the value of body path (.*) as (.*) in global scope
```

The simplest way to adopt these expressions is to create a symlink from node_modules/apickli/apickli-gherkin.js to features/step_definitions/apickli-gherkin.js

```sh
$ ln -s node_modules/apickli/apickli-gherkin.js features/step_definitions/apickli-gherkin.js
```

If using Windows, follow this guide to create a symlink: [How-To Geek Guide](http://www.howtogeek.com/howto/16226/complete-guide-to-symbolic-links-symlinks-on-windows-or-linux/).
        
## Contributing

If you have any comments or suggestions, feel free to raise [an issue](https://github.com/apickli/apickli/issues) or fork the project and issue a pull request with suggested improvements.
