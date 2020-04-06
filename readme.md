# Keells Supermarket Monitor

This repo contains a bash script running on a docker container to talk to a webhook which accepts the payload
```
{ 'text': 'some-message'}
```

Environment Variable required to run
```CRON_URL="<some-webhook-url>"```

docker run -e CRON_URL=<your-webhook> nj93/keells-monitoring:1.0.0