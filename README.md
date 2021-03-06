[![CircleCI](https://circleci.com/gh/randallreedjr/quosra.svg?style=shield)](https://circleci.com/gh/randallreedjr/quosra)

# Quosra

Rails app for a question and answer site vaguely modeled after Quora, created for SRA.

Built using Rails 5.1.1 and Ruby 2.4.1.

## Continuous Integration

Quosra is setup to use Circle CI for continuous integration.

## Deployment

Quosra is hosted on [Heroku](https://quosra.herokuapp.com). Pushes/merges to the master branch will trigger a build and deploy to Heroku through Circle CI.

## Authentication

Authentication is provided by Devise. The forgot password link is disabled, since we are not setting up a mailer.

## Search

Full-text search of questions, answers, and categories, as well as a category filter, is implemented using Elasticsearch v5.4.1. The SearchBox add-on has been activated on Heroku to run the Elasticsearch server.
