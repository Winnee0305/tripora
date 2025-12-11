# Flight Autocomplete Setup Guide

This guide explains how to set up and use the AviationStack API for flight autocomplete functionality in the Tripora app.

## Prerequisites

1. Sign up for a free account at [AviationStack](https://aviationstack.com/)
2. Get your API access key from the dashboard

## Configuration

### Step 1: Add your API key

Open the file:
```
lib/core/services/flight_autocomplete_service.dart
```

Replace the placeholder API key with your actual key:
```dart
static const String _apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

### Step 2: Understand API Limitations

**Free Plan Limits:**
- 100 API requests per month
- Flight data updated hourly
- HTTP only (no HTTPS)
- Historical data: 1 month

**Paid Plans:**
- More API requests
- HTTPS support
- Real-time data
- Extended historical data

## How It Works

### Flight Number Autocomplete

When a user types a flight number (e.g., "AA100", "BA123"):

1. **Debounced Search**: After 800ms of typing pause, the app searches for flights
2. **API Request**: Fetches flight data from AviationStack
3. **Auto-fill**: When user selects a suggestion, the form auto-fills:
   - Airline name
   - Departure airport (with IATA code)
   - Arrival airport (with IATA code)
   - Scheduled departure time
   - Scheduled arrival time

### Example API Response Structure

```json
{
  "data": [
    {
      "flight": {
        "iata": "AA100"
      },
      "airline": {
        "name": "American Airlines",
        "iata": "AA"
      },
      "departure": {
        "airport": "John F Kennedy International",
        "iata": "JFK",
        "scheduled": "2025-12-12T14:30:00+00:00"
      },
      "arrival": {
        "airport": "Los Angeles International",
        "iata": "LAX",
        "scheduled": "2025-12-12T17:45:00+00:00"
      },
      "flight_status": "scheduled"
    }
  ]
}
```

## Features

### 1. Flight Search
```dart
searchFlightByNumber(String flightNumber)
```
- Searches for flights by IATA flight number
- Returns list of matching flights with full details

### 2. Airline Info
```dart
getAirlineInfo(String iataCode)
```
- Gets detailed airline information by IATA code
- Useful for displaying airline logos/details

### 3. Airport Search
```dart
searchAirports(String query)
```
- Searches airports by name or code
- Can be used for manual airport selection

## User Experience

1. **Type Flight Number**: User enters flight number in the field
2. **Loading Indicator**: Shows spinner while searching
3. **Suggestions Appear**: List of matching flights displayed
4. **Tap to Select**: User taps a suggestion
5. **Form Auto-fills**: All flight details populated automatically
6. **Manual Override**: User can still edit any field if needed

## Error Handling

The service handles various error scenarios:
- No internet connection
- API rate limit exceeded
- Invalid flight number
- No results found

All errors are logged to console in debug mode and fail gracefully.

## Testing

### Test Flight Numbers (Use real ones from major airlines)
- AA100 (American Airlines)
- BA123 (British Airways)
- DL456 (Delta Airlines)
- UA789 (United Airlines)

### Note
- Flight numbers must be currently scheduled flights
- Data may vary based on your API plan
- Free plan has limited historical data

## Alternatives

If you prefer not to use AviationStack, you can:

1. **Manual Entry**: Remove autocomplete, keep manual fields
2. **Other APIs**: 
   - FlightAware (more expensive)
   - Aviation Edge
   - AeroDataBox
3. **Local Database**: Create your own flight database
4. **Airline-specific APIs**: Use individual airline APIs

## Privacy & Security

- API key should be stored securely (consider environment variables for production)
- Never commit API keys to public repositories
- Consider backend proxy for production to hide API key
- Implement rate limiting to prevent abuse

## Production Recommendations

For production deployment:

1. **Move API key to backend**: Create a server endpoint that proxies requests
2. **Implement caching**: Cache frequent flight searches
3. **Add fallback**: Graceful degradation if API is unavailable
4. **Monitor usage**: Track API calls to avoid hitting limits
5. **Error reporting**: Log errors to analytics service

## Support

For issues with:
- AviationStack API: Contact support@aviationstack.com
- This implementation: Check Flutter/Dart documentation
