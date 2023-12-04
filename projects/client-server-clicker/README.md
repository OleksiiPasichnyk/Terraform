# client-server-clicker

Application consists of 3 containers:

- Web server: `webfront`
- Backend server: `apiserver`
- Container, emulating user interaction with web server: `clicker`

## webfront `/`

Offers to fill a form. Submits form to `/form_submit`

## webfront `/form_submit`

Receives form data. Sends data as JSON to API provided by `apiserver`. Receives JSON response, extracts message from it and displays on the web page

## apiserver

Listens on port 7001

Provides API `POST /`

Request example:

```json
{
    "name": "Alice",
    "profession": "Doctor"
}
```

Response example:

```json
{
    "message": "Alice is a cool Doctor"
}
```

Curl for testing:

```bash
curl -X POST http://apiserver:7001/ \
    -H "Content-Type: application/json" \
    -d '{"name": "Alice", "profession": "Doctor"}'
```

## clicker

Opens `webfront` `/` page, finds submit button, sends example request to the page responsible for the form action. Repeats after configurable interval
