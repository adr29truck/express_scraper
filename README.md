# Express Scraper

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
<!-- - [Contributing](../CONTRIBUTING.md) -->

## About <a name = "about"></a>

This small Ruby application utilizes webscraping in order to fetch the current lunch menu for Chalmers Express, and sends a daily message in Slack informing about todays choises.

## Getting Started <a name = "getting_started"></a>

### Without docker

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

To get upp and running clone the repository and install all the dependencies using ``` bundle install ```
Then create a .env file containing the webhook link ``` WEBHOOK = https://... ```
You will also need to have google chrome installed on your device and a supported ChromeDriver. Easely install the ChromeDriver from <a href="https://chromedriver.chromium.org/downloads">chromedriver.chromium.org/downloads</a>

You are now set and ready to run ``` ruby scraper.rb ``` or ``` rackup ``` in the terminal. Then navigate to ``` http://localhost:REPLACE_WITH_PORT_GIVEN_WHEN STARTING_THE_SERVER/send_menu ``` to trigger the webscraping event.

### Using docker

To get the current container from master run <br>
```$ docker pull adr29truck/expressscraper:latest ```
Or build it manually by first cloning this repo.

To run the container you can use the following command <br>
``` $ docker run --rm --tty -d --p 9000:4244 -e PORT=4244 -e RACK_ENV=production -e WEBHOOK=REPLACE_WITH_WEBHOOK_URL --name expressscraper expressscraper:latest ```

## Deploying to heroku
To deploy the dockercontainer to Heroku use the following commands <br>
``` $ docker tag expressscraper:latest registry.heroku.com/express-scraper/web ``` <br>
``` $ docker push registry.heroku.com/express-scraper/web ``` <br>
``` $ heroku container:release web -a express-scraper```
