# Portal Upstream Rerouter

An NGINX Docker image to support rerouting some of the upstream APIs used by the
Europeana website (aka "the portal").


## Usage

### Local

Build the Docker image:
```
docker build -t europeana/portal-upstream-rerouter .
```

Create an env file with any environment variables you want to set.

Example:

```.env
# .env
RECORD_API_URL=https://api.example.org/record
```

Run the image:
```
docker run \
  -d -p 8080:80 --name europeana-portal-upstream-rerouter --env-file .env \
  europeana/portal-upstream-rerouter
```

The gateway will now be available at http://localhost:8080/.

### Cloud Foundry

These instructions for deploying to Cloud Foundry (CF) assume a  Docker image
has been pushed to a repository, and uses the CF CLI.

Deployment files are located in [deploy/cloud-foundry](./deploy/cloud-foundry).

1. Copy vars.yml.example to vars.yml and adjust any of
  the environment variables as needed.
2. Push with the CF CLI:
    ```
    cf push portal-upstream-rerouter -f manifest.yml --vars-file vars.yml
    ```

## Configuration

Configuration settings are made available as environment variables on the Docker
container.

### General
* `PORT`: the TCP port on which to listen for HTTP requests; default 80
* `RESOLVER`: the address of DNS resolver(s) to use for upstream server hostname
  resolution; defaults to that in the container's /etc/resolv.conf at runtime
  via [docker-entrypoint.sh](./src/docker-entrypoint.sh)
* `PORT_IN_REDIRECT`: sets NGINX `port_in_redirect` to "on" or "off"; default
  "on" (preferred for development and testing); set to "off" for deployments
  where ports 80 and/or 443 are forwarded to the gateway by an external router,
  e.g. in Cloud Foundry

### Portal

Requests to this gateway will be reverse-proxied to the portal, which has two
configuration settings: one for URL, and one for host.

* `PORTAL_URL`: the full URL with scheme, hostname andport to use in the proxied
  requests, i.e. at which the server is accessible from the gateway, which may
  (or may not) be on a private network not accessible to clients, such as when
  using [Cloud Foundry container-to-container networking](https://docs.cloudfoundry.org/devguide/deploy-apps/cf-networking.html).
  Examples: `https://portal.europeana.eu`; `http://portal.apps.internal:8080`
* `PORTAL_HOST`: the hostname to send in the HTTP `Host` header of the proxied
  request. Example: `portal.europeana.eu`

### Upstream rerouting

By default, no APIs will be rerouted and this gateway will act as a simple
reverse proxy to the portal. To reroute the URLs of particular APIs, set
the relevant environment variable from those below, and a custom HTTP request
header will be included in the proxied request, which the portal will observe
and favour over its default.

* `ANNOTATION_API_URL`: Annotation API
* `ENTITY_API_URL`: Entity API
* `RECOMMENDATION_API_URL`: Recommendation API
* `RECORD_API_URL`: Record API
* `SET_API_URL`: Set API

NB: rerouting of other upstream APIs in this way is not at present supported.


## License

Licensed under the EUPL v1.2.

For full details, see [LICENSE.md](LICENSE.md).
