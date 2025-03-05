#!/bin/bash

# URL Shortener Script für 4or.de API
# Verwendung: ./urlshortener.sh -u https://www.beispiel.de/ -k DEIN_API_KEY [weitere Optionen]

# Farben für Ausgaben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default Werte
URL=""
API_KEY=""   # Bei bedarf einfach hier den API Key hinterlegen
DOMAIN_ID=1  # Standardwert für domain_id
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
SHOW_HELP=false
COPY_TO_CLIPBOARD=false
QUIET_MODE=false
VERBOSE_MODE=false

# Hilfefunktion
show_help() {
  echo -e "${BLUE}URL Shortener für 4or.de${NC}"
  echo ""
  echo "Verwendung: $0 [optionen]"
  echo ""
  echo "Erforderliche Optionen:"
  echo "  -u, --url URL               Die zu verkürzende URL"
  echo "  -k, --apikey KEY            Dein API-Key"
  echo ""
  echo "Allgemeine Optionen:"
  echo "  -h, --help                  Zeigt diese Hilfe an"
  echo "  -c, --clipboard             Kopiert die verkürzte URL in die Zwischenablage"
  echo "  -q, --quiet                 Nur die URL ausgeben, keine weiteren Meldungen"
  echo "  -v, --verbose               Ausführliche Ausgabe (für Fehlersuche)"
  echo ""
  echo "URL-Optionen:"
  echo "  -d, --domain ID             Domain-ID (Standard: 1)"
  echo "  -a, --alias TEXT            Eigener Link-Alias"
  echo "  -p, --password TEXT         Link-Passwort"
  echo "  -s, --space ID              Space-ID"
  echo "  --disabled 0|1              Link deaktivieren (0=aktiv, 1=deaktiviert)"
  echo "  --privacy 0|1|2             Datenschutzeinstellung (0=öffentlich, 1=privat, 2=passwort)"
  echo "  --privacy-password TEXT     Passwort für Statistikseite"
  echo "  --exp-url URL               Weiterleitungs-URL nach Ablauf"
  echo "  --exp-date YYYY-MM-DD       Ablaufdatum"
  echo "  --exp-time HH:MM            Ablaufzeit"
  echo "  --exp-clicks N              Maximale Anzahl an Klicks"
  echo ""
  echo "Beispiel:"
  echo "  $0 -u https://www.beispiel.de/ -k DEIN_API_KEY -a meinlink"
  exit 0
}

# Parameter parsen
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -u|--url)
      URL="$2"
      shift
      shift
      ;;
    -k|--apikey)
      API_KEY="$2"
      shift
      shift
      ;;
    -d|--domain)
      DOMAIN_ID="$2"
      shift
      shift
      ;;
    -a|--alias)
      ALIAS="$2"
      shift
      shift
      ;;
    -p|--password)
      PASSWORD="$2"
      shift
      shift
      ;;
    -s|--space)
      SPACE_ID="$2"
      shift
      shift
      ;;
    --disabled)
      DISABLED="$2"
      shift
      shift
      ;;
    --privacy)
      PRIVACY="$2"
      shift
      shift
      ;;
    --privacy-password)
      PRIVACY_PASSWORD="$2"
      shift
      shift
      ;;
    --exp-url)
      EXPIRATION_URL="$2"
      shift
      shift
      ;;
    --exp-date)
      EXPIRATION_DATE="$2"
      shift
      shift
      ;;
    --exp-time)
      EXPIRATION_TIME="$2"
      shift
      shift
      ;;
    --exp-clicks)
      EXPIRATION_CLICKS="$2"
      shift
      shift
      ;;
    -c|--clipboard)
      COPY_TO_CLIPBOARD=true
      shift
      ;;
    -q|--quiet)
      QUIET_MODE=true
      shift
      ;;
    -v|--verbose)
      VERBOSE_MODE=true
      shift
      ;;
    -h|--help)
      SHOW_HELP=true
      shift
      ;;
    *)
      echo -e "${RED}Fehler: Unbekannter Parameter: $1${NC}"
      echo "Verwende '$0 --help' für eine Liste der verfügbaren Optionen."
      exit 1
      ;;
  esac
done

# Zeige Hilfe, wenn angefordert
if [ "$SHOW_HELP" = true ]; then
  show_help
fi

# Prüfen ob erforderliche Parameter vorhanden sind
if [ -z "$URL" ]; then
  echo -e "${RED}Fehler: URL ist erforderlich (-u, --url)${NC}"
  echo "Verwende '$0 --help' für eine Liste der verfügbaren Optionen."
  exit 1
fi

if [ -z "$API_KEY" ]; then
  echo -e "${RED}Fehler: API-Key ist erforderlich (-k, --apikey)${NC}"
  echo "Verwende '$0 --help' für eine Liste der verfügbaren Optionen."
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
if [ "$VERBOSE_MODE" = true ]; then
  echo -e "${YELLOW}Ausführen des Befehls:${NC}"
  echo "$CURL_CMD"
fi

# Zeige Fortschritt an, außer im Quiet-Modus
if [ "$QUIET_MODE" = false ] && [ "$VERBOSE_MODE" = false ]; then
  echo -e "${YELLOW}Verkürze URL...${NC}"
fi

# Sende die Anfrage
RESPONSE=$(eval $CURL_CMD)

# Prüfe auf Fehler im Response
if echo "$RESPONSE" | grep -q "error\|message"; then
  if [ "$QUIET_MODE" = false ]; then
    echo -e "${RED}Fehler bei der API-Anfrage:${NC}"
    echo "$RESPONSE"
  fi
  exit 1
fi

# Extrahiere die verkürzte URL
SHORT_URL=$(echo "$RESPONSE" | grep -o '"short_url":"[^"]*"' | cut -d'"' -f4)

if [ -z "$SHORT_URL" ]; then
  # Fallback-Methode für andere JSON-Formate
  SHORT_URL=$(echo "$RESPONSE" | grep -o '"shortUrl":"[^"]*"' | cut -d'"' -f4)
  
  if [ -z "$SHORT_URL" ]; then
    if [ "$QUIET_MODE" = false ]; then
      echo -e "${RED}Konnte keine verkürzte URL aus der Antwort extrahieren.${NC}"
      if [ "$VERBOSE_MODE" = true ]; then
        echo "Antwort:"
        echo "$RESPONSE"
      fi
    fi
    exit 1
  fi
fi

# Entferne Escape-Zeichen aus der URL (wie \/ zu /)
SHORT_URL=$(echo "$SHORT_URL" | sed 's/\\//g')

# Ausgabe der URL
if [ "$QUIET_MODE" = false ]; then
  echo -e "${GREEN}Verkürzte URL:${NC} $SHORT_URL"
else
  echo "$SHORT_URL"
fi

# In die Zwischenablage kopieren, wenn gewünscht
if [ "$COPY_TO_CLIPBOARD" = true ]; then
  # Prüfe, ob eines der Clipboard-Befehle verfügbar ist
  if command -v xclip &> /dev/null; then
    echo -n "$SHORT_URL" | xclip -selection clipboard
    if [ "$QUIET_MODE" = false ]; then
      echo -e "${BLUE}URL wurde in die Zwischenablage kopiert (xclip).${NC}"
    fi
  elif command -v xsel &> /dev/null; then
    echo -n "$SHORT_URL" | xsel -ib
    if [ "$QUIET_MODE" = false ]; then
      echo -e "${BLUE}URL wurde in die Zwischenablage kopiert (xsel).${NC}"
    fi
  elif command -v pbcopy &> /dev/null; then
    echo -n "$SHORT_URL" | pbcopy
    if [ "$QUIET_MODE" = false ]; then
      echo -e "${BLUE}URL wurde in die Zwischenablage kopiert (pbcopy).${NC}"
    fi
  else
    if [ "$QUIET_MODE" = false ]; then
      echo -e "${YELLOW}Warnung: Konnte URL nicht in Zwischenablage kopieren. Installiere xclip, xsel oder pbcopy.${NC}"
    fi
  fi
fi

exit 0
