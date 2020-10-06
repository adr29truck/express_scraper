# Express Scraper

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
<!-- - [Contributing](../CONTRIBUTING.md) -->

## About <a name = "about"></a>

This small Ruby application utilizes webscraping in order to fetch the current lunch menu for Chalmers Express, and sends a daily message in Slack informing about todays choises.

## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

To get upp and running clone the repository and install all the dependencies using ``` bundle install ```
Then create a .env file containing the webhook link ``` WEBHOOK = https://... ```

You are now set and ready to run ``` ruby scraper.rb ``` in the terminal and a message will be sent to the webhook url.
