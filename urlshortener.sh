#!/bin/bash

# URL Shortener Script für 4or.de API
# Verwendung: ./urlshortener.sh -url https://www.beispiel.de/ -apikey DEIN_API_KEY [weitere Optionen]

# Default Werte
URL=""
API_KEY=""
DOMAIN_ID=5  # Standardwert für domain_id
ALIAS=""
PASSWORD=""
SPACE_ID=""
PIXEL_IDS=""
DISABLED=0
PRIVACY=0
PRIVACY_PASSWORD=""
EXPIRATION_URL=""
EXPIRATION_DATE=""
EXPIRATION_TIME=""
EXPIRATION_CLICKS=""
TARGET_TYPE=0

# Parameter parsen
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -url|--url)
      URL="$2"
      shift
      shift
      ;;
    -apikey|--apikey)
      API_KEY="$2"
      shift
      shift
      ;;
    -domain|--domain)
      DOMAIN_ID="$2"
      shift
      shift
      ;;
    -alias|--alias)
      ALIAS="$2"
      shift
      shift
      ;;
    -password|--password)
      PASSWORD="$2"
      shift
      shift
      ;;
    -space|--space)
      SPACE_ID="$2"
      shift
      shift
      ;;
    -disabled|--disabled)
      DISABLED="$2"
      shift
      shift
      ;;
    -privacy|--privacy)
      PRIVACY="$2"
      shift
      shift
      ;;
    -privacypass|--privacy-password)
      PRIVACY_PASSWORD="$2"
      shift
      shift
      ;;
    -expurl|--expiration-url)
      EXPIRATION_URL="$2"
      shift
      shift
      ;;
    -expdate|--expiration-date)
      EXPIRATION_DATE="$2"
      shift
      shift
      ;;
    -exptime|--expiration-time)
      EXPIRATION_TIME="$2"
      shift
      shift
      ;;
    -expclicks|--expiration-clicks)
      EXPIRATION_CLICKS="$2"
      shift
      shift
      ;;
    *)
      echo "Unbekannter Parameter: $1"
      exit 1
      ;;
  esac
done

# Prüfen ob erforderliche Parameter vorhanden sind
if [ -z "$URL" ]; then
  echo "Fehler: URL ist erforderlich (-url parameter)"
  exit 1
fi

if [ -z "$API_KEY" ]; then
  echo "Fehler: API-Key ist erforderlich (-apikey parameter)"
  exit 1
fi

# Baue den CURL-Befehl mit einzelnen --data-urlencode Parametern
CURL_CMD="curl --silent --location --request POST 'https://4or.de/api/v1/links'"
CURL_CMD="$CURL_CMD --header 'Content-Type: application/x-www-form-urlencoded'"
CURL_CMD="$CURL_CMD --header 'Authorization: Bearer $API_KEY'"

# Füge die erforderlichen Parameter hinzu
CURL_CMD="$CURL_CMD --data-urlencode 'url=$URL'"
CURL_CMD="$CURL_CMD --data-urlencode 'domain_id=$DOMAIN_ID'"

# Füge optionale Parameter hinzu, wenn sie gesetzt sind
if [ ! -z "$ALIAS" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'alias=$ALIAS'"; fi
if [ ! -z "$PASSWORD" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'password=$PASSWORD'"; fi
if [ ! -z "$SPACE_ID" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'space_id=$SPACE_ID'"; fi
if [ ! -z "$PIXEL_IDS" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'pixel_ids=$PIXEL_IDS'"; fi
if [ ! -z "$DISABLED" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'disabled=$DISABLED'"; fi
if [ ! -z "$PRIVACY" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'privacy=$PRIVACY'"; fi
if [ ! -z "$PRIVACY_PASSWORD" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'privacy_password=$PRIVACY_PASSWORD'"; fi
if [ ! -z "$EXPIRATION_URL" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'expiration_url=$EXPIRATION_URL'"; fi
if [ ! -z "$EXPIRATION_DATE" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'expiration_date=$EXPIRATION_DATE'"; fi
if [ ! -z "$EXPIRATION_TIME" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'expiration_time=$EXPIRATION_TIME'"; fi
if [ ! -z "$EXPIRATION_CLICKS" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'expiration_clicks=$EXPIRATION_CLICKS'"; fi
if [ ! -z "$TARGET_TYPE" ]; then CURL_CMD="$CURL_CMD --data-urlencode 'target_type=$TARGET_TYPE'"; fi

# Für Debug-Zwecke
# echo "$CURL_CMD"

# Sende die Anfrage
RESPONSE=$(eval $CURL_CMD)

# Prüfe auf Fehler im Response
if echo "$RESPONSE" | grep -q "error\|message"; then
  echo "Fehler bei der API-Anfrage:"
  echo "$RESPONSE"
  exit 1
fi

# Extrahiere und zeige die verkürzte URL an
# Da das Format sich geändert hat, müssen wir nach "short_url" statt "shortUrl" suchen
SHORT_URL=$(echo "$RESPONSE" | grep -o '"short_url":"[^"]*"' | cut -d'"' -f4)

if [ -z "$SHORT_URL" ]; then
  # Fallback-Methode für andere JSON-Formate
  SHORT_URL=$(echo "$RESPONSE" | grep -o '"shortUrl":"[^"]*"' | cut -d'"' -f4)
  
  if [ -z "$SHORT_URL" ]; then
    echo "Konnte keine verkürzte URL aus der Antwort extrahieren."
    exit 1
  fi
fi

# Entferne Escape-Zeichen aus der URL (wie \/ zu /)
echo "$SHORT_URL" | sed 's/\\//g'
