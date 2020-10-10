# Express Scraper
Dev<br>
![RuboCopLintDev](https://github.com/adr29truck/express_scraper/workflows/RuboCop/badge.svg?branch=dev)
![DockerHubPush](https://github.com/adr29truck/express_scraper/workflows/Docker/badge.svg?branch=dev)
![UnitTests](https://github.com/adr29truck/express_scraper/workflows/Tests/badge.svg?branch=dev)
[![CodeFactor](https://www.codefactor.io/repository/github/adr29truck/express_scraper/badge)](https://www.codefactor.io/repository/github/adr29truck/express_scraper)
<br>Main<br>
![RuboCopLintMain](https://github.com/adr29truck/express_scraper/workflows/RuboCop/badge.svg?branch=main)
![DockerHubPush](https://github.com/adr29truck/express_scraper/workflows/Docker/badge.svg?branch=main)
![UnitTests](https://github.com/adr29truck/express_scraper/workflows/Tests/badge.svg?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/adr29truck/express_scraper/badge/main)](https://www.codefactor.io/repository/github/adr29truck/express_scraper/overview/main)
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
You will also need to have google chrome installed on your device and a supported ChromeDriver. Easily install the ChromeDriver from <a href="https://chromedriver.chromium.org/downloads">chromedriver.chromium.org/downloads</a>

You are now set and ready to run ``` rackup ``` in the terminal. Then navigate to ``` http://localhost:REPLACE_WITH_PORT_GIVEN_WHEN_STARTING_THE_SERVER/send_menu ``` to trigger the webscraping event.

### Using docker

To get the current container from main run <br>
```$ docker pull adr29truck/expressscraper:latest ```<br>
or for the current dev container <br>
```$ docker pull adr29truck/expressscraper:dev ```<br>
Or build it manually by first cloning this repo.

To run the container you can use the following command <br>
``` $ docker run --rm --tty -d --p 9000:4244 -e PORT=4244 -e RACK_ENV=production -e WEBHOOK=REPLACE_WITH_WEBHOOK_URL --name expressscraper expressscraper:REPLACE_WITH_TAG ```

## Manually deploying to heroku
To deploy the dockercontainer to Heroku use the following commands <br>
``` $ docker tag expressscraper:latest registry.heroku.com/APP_NAMEr/web ``` <br>
``` $ docker push registry.heroku.com/APP_NAMer/web ``` <br>
``` $ heroku container:release web -a APP_NAME```
