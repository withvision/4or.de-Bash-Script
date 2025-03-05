# 4or.de-Bash-Script

A small Bash script for the command line that allows you to shorten URLs using the 4or.de URL shortener service.

It is easy to use on the command line and can be easily customized. I built it to quickly and conveniently shorten URLs via the terminal on Mac and Linux for use on social media platforms like Threads, Bluesky, and Twitter (X.com). After shortening, it simply outputs the short URL.

Please note that you need an API key from the 4or.de URL shortener service to use this script. To get one, you need to create an account, but this also works with the free account.

Once logged in, you can find the API key under: **Home > Account > API**.

Why 4or.de? It is DSGVO/GDPR-compliant and does not store unnecessary data, making it a good choice for use in Germany. Additionally, the domain is quite neutral.

## Installation and Usage

### Installation

1. Save the script as `urlshortener.sh`
2. Make it executable:
   ```sh
   chmod +x urlshortener.sh
   ```

### Usage

Basic usage with the required parameters:
```sh
./urlshortener.sh -u https://www.demourl.com/ -k YOUR_API_KEY
```

Show help:
```sh
./urlshortener.sh --help
```

## Features

- Easy shortening of URLs from the command line
- Colorful and informative output
- Optional automatic clipboard copying
- Quiet mode for use in other scripts
- Verbose mode for debugging
- Comprehensive help with `-h` or `--help`

Example with additional options:
```sh
./urlshortener.sh -u https://www.demourl.com/ -k YOUR_API_KEY -a mylink -c
```

## Available Parameters

| Parameter | Short | Description |
|-----------|-------|-------------|
| `--url` | `-u` | The URL to be shortened (required) |
| `--apikey` | `-k` | Your API key (required) |
| `--help` | `-h` | Show help information |
| `--clipboard` | `-c` | Copy the shortened URL to clipboard |
| `--quiet` | `-q` | Output only the URL, no other messages |
| `--verbose` | `-v` | Detailed output (for debugging) |
| `--domain` | `-d` | Domain ID (default: `5`) |
| `--alias` | `-a` | Custom link alias |
| `--password` | `-p` | Password for the shortened link |
| `--space` | `-s` | Space ID |
| `--disabled` | | Set to 1 to disable the link (default: 0) |
| `--privacy` | | Privacy setting (0=public, 1=private, 2=password) |
| `--privacy-password` | | Password for statistics page |
| `--exp-url` | | Redirect URL after expiration |
| `--exp-date` | | Expiration date (YYYY-MM-DD) |
| `--exp-time` | | Expiration time (HH:MM) |
| `--exp-clicks` | | Maximum number of clicks |

## Examples

1. Basic usage:
```sh
./urlshortener.sh -u https://www.example.com/ -k YOUR_API_KEY
```

2. With custom alias and clipboard copying:
```sh
./urlshortener.sh -u https://www.example.com/ -k YOUR_API_KEY -a mylink -c
```

3. Set expiration date and time:
```sh
./urlshortener.sh -u https://www.example.com/ -k YOUR_API_KEY --exp-date 2025-12-31 --exp-time 23:59
```

4. For use in other scripts (quiet mode):
```sh
SHORT_URL=$(./urlshortener.sh -u https://www.example.com/ -k YOUR_API_KEY -q)
echo "Generated short URL: $SHORT_URL"
```

## Output

By default, the script provides informative, colored output:
```
Verkürzte URL: https://4or.de/abcd1
```

With quiet mode (`-q`), only the URL is output:
```
https://4or.de/abcd1
```

## Get an API Key

To use this script, you need an API key from the [4or.de URL Shortener](https://4or.de/). You can register for an account [here](https://4or.de/register).
