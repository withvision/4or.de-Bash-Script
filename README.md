# 4or.de-Bash-Script
A small Bash script for the command line that allows you to shorten URLs using the 4or.de URL shortener service.

A small Bash script for the command line that allows you to shorten URLs using the 4or.de URL shortener service.
It is easy to use on the command line and can be easily customized. I built it to quickly and conveniently shorten URLs via the terminal on Mac and Linux for use on social media platforms like Threads, Bluesky, and Twitter (X.com). After shortening, it simply outputs the short URL.

Please note that you need an API key from the 4or.de URL shortener service to use this script. To get one, you need to create an account, but this also works with the free account.

Once logged in, you can find the API key under: **Home > Account > API**.

Why 4or.de? It is DSGVO/GDPR-compliant and does not store unnecessary data, making it a good choice for use in Germany. Additionally, the domain is quite neutral.


# URL Shortener Script

## Installation and Usage

### Installation
1. Save the script as `urlshortener.sh`
2. Make it executable:
   ```sh
   chmod +x urlshortener.sh
   ```

### Usage
Run the script with the required parameters:
```sh
./urlshortener.sh -url https://www.demourl.com/ -apikey YOUR_API_KEY
```

## Features
- The script requires the URL and API key as mandatory parameters.
- The domain ID is set to `1` by default (modify if necessary).
- You can add additional optional parameters, for example:
  ```sh
  ./urlshortener.sh -url https://www.demourl.com/ -apikey YOUR_API_KEY -alias mylink -privacy 1 -expdate 2023-12-31
  ```

## Available Parameters
| Parameter            | Description |
|----------------------|-------------|
| `-url` or `--url`   | The URL to be shortened (required) |
| `-apikey` or `--apikey` | Your API key (required) |
| `-domain` or `--domain` | Domain ID (default: `1`) |
| `-alias` or `--alias` | Custom link alias |
| `-password` or `--password` | Password for the shortened link |
| `-space` or `--space` | Space ID |
| `-disabled` or `--disabled` | 0 (active) or 1 (disabled) |
| `-privacy` or `--privacy` | Privacy setting (0, 1, or 2) |
| `-privacypass` or `--privacy-password` | Password for the statistics page |
| `-expurl` or `--expiration-url` | Redirect URL after expiration |
| `-expdate` or `--expiration-date` | Expiration date (YYYY-MM-DD) |
| `-exptime` or `--expiration-time` | Expiration time (HH:MM) |
| `-expclicks` or `--expiration-clicks` | Maximum number of clicks |

## Output
The shortened URL is directly displayed in the command line.

