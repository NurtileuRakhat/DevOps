## Task 10

### Steps

1. chmod +x task10.sh
2. ./task10.sh
3. Use your domain name,not www.mysite

Expected output
```bash
curl -X POST http://medhelper.xyz/token \
-H "Content-Type: application/json" \
-d '{
  "client_id": "test_client",
  "client_secret": "secret123",
  "scope": "read",
  "grant_type": "client_credentials"
}'
{"access_token":"61c9f3c8-7708-41db-923f-194b5da4ea67","expires_in":7200,"refresh_token":"","scope":"read","security_level":"normal","token_type":"Bearer"}
```
