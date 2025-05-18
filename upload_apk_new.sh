#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Define variables
APK_PATH=build/app/outputs/flutter-apk/app-release.apk
FOLDER_ID="1CK55EUd0suHdmIm_cowoHI4LCzwczQfm"
SERVICE_ACCOUNT_FILE="gcloud-service-key.json"
APK_NAME="groute_pro.apk"

echo "Starting APK upload process..."

# Check dependencies
for cmd in jq openssl curl; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is required but not installed"
        exit 1
    fi
done

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "Error: APK file not found at $APK_PATH"
    exit 1
fi

# Check if environment variable exists
if [ -z "$GCLOUD_SERVICE_ACCOUNT_JSON" ]; then
    echo "Error: GCLOUD_SERVICE_ACCOUNT_JSON environment variable is not set"
    exit 1
fi

echo "Writing service account JSON to file..."
# Write service account JSON to file - use echo with proper quoting to preserve formatting
echo "$GCLOUD_SERVICE_ACCOUNT_JSON" > $SERVICE_ACCOUNT_FILE

# Verify the service account file was created and has content
if [ ! -s "$SERVICE_ACCOUNT_FILE" ]; then
    echo "Error: Service account file is empty or was not created"
    exit 1
fi

# Debug: Check the content of the service account file (remove sensitive info)
echo "Checking service account file format..."
if ! jq empty $SERVICE_ACCOUNT_FILE 2>/dev/null; then
    echo "Error: Service account file is not valid JSON"
    echo "First 100 characters: $(head -c 100 $SERVICE_ACCOUNT_FILE)"
    echo "Last 100 characters: $(tail -c 100 $SERVICE_ACCOUNT_FILE)"
    exit 1
fi

# Get current time
CURRENT_TIME=$(date +%s)
EXPIRY_TIME=$((CURRENT_TIME + 3600))

echo "Extracting credentials..."
# Extract credentials
CLIENT_EMAIL=$(jq -r '.client_email' $SERVICE_ACCOUNT_FILE)
PRIVATE_KEY=$(jq -r '.private_key' $SERVICE_ACCOUNT_FILE)

# Verify credentials were extracted
if [ -z "$CLIENT_EMAIL" ] || [ "$CLIENT_EMAIL" == "null" ]; then
    echo "Error: Failed to extract client_email from service account file"
    exit 1
fi

if [ -z "$PRIVATE_KEY" ] || [ "$PRIVATE_KEY" == "null" ]; then
    echo "Error: Failed to extract private_key from service account file"
    exit 1
fi

echo "Creating JWT token..."
# Create JWT
JWT_HEADER='{"alg":"RS256","typ":"JWT"}'
JWT_HEADER_BASE64=$(echo -n "$JWT_HEADER" | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
JWT_PAYLOAD="{\"iss\":\"$CLIENT_EMAIL\",\"scope\":\"https://www.googleapis.com/auth/drive\",\"aud\":\"https://oauth2.googleapis.com/token\",\"exp\":$EXPIRY_TIME,\"iat\":$CURRENT_TIME}"
JWT_PAYLOAD_BASE64=$(echo -n "$JWT_PAYLOAD" | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
JWT_UNSIGNED="$JWT_HEADER_BASE64.$JWT_PAYLOAD_BASE64"
echo "$PRIVATE_KEY" > private_key.pem
JWT_SIGNATURE=$(echo -n "$JWT_UNSIGNED" | openssl dgst -binary -sha256 -sign private_key.pem | openssl base64 -e -A | tr '+/' '-_' | tr -d '=')
rm private_key.pem
JWT_TOKEN="$JWT_UNSIGNED.$JWT_SIGNATURE"

echo "Getting access token..."
# Get access token
OAUTH_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=$JWT_TOKEN" \
  https://oauth2.googleapis.com/token)
ACCESS_TOKEN=$(echo $OAUTH_RESPONSE | jq -r '.access_token')

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
    echo "Error: Failed to get access token. Response: $OAUTH_RESPONSE"
    exit 1
fi

echo "Checking for existing file..."
# Delete existing file if present
EXISTING_FILE=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=name='$APK_NAME'+and+'$FOLDER_ID'+in+parents+and+trashed=false")
FILE_ID=$(echo $EXISTING_FILE | jq -r '.files[0].id')
if [ -n "$FILE_ID" ] && [ "$FILE_ID" != "null" ]; then
    echo "Deleting existing file with ID: $FILE_ID"
    DELETE_RESPONSE=$(curl -s -X DELETE -H "Authorization: Bearer $ACCESS_TOKEN" \
      "https://www.googleapis.com/drive/v3/files/$FILE_ID")
    if [ -n "$DELETE_RESPONSE" ]; then
        echo "Warning: Delete response not empty: $DELETE_RESPONSE"
    fi
fi

echo "Uploading APK to Google Drive..."
# Upload APK
UPLOAD_RESPONSE=$(curl -s -X POST -L \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -F "metadata={name:'$APK_NAME',parents:['$FOLDER_ID']};type=application/json;charset=UTF-8" \
  -F "file=@$APK_PATH;type=application/vnd.android.package-archive" \
  "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart")

# Clean up
rm -f $SERVICE_ACCOUNT_FILE

# Check upload status
if [[ $UPLOAD_RESPONSE == *"id"* ]]; then
    UPLOADED_FILE_ID=$(echo $UPLOAD_RESPONSE | jq -r '.id')
    echo "Upload successful! File ID: $UPLOADED_FILE_ID"
    exit 0
else
    echo "Upload failed. Response: $UPLOAD_RESPONSE"
    exit 1
fi