FROM nginx:mainline

ENV PORT=80 \
    RESOLVER= \
    PORT_IN_REDIRECT=on \
    PORTAL_HOST=portaljs.europeana.eu \
    PORTAL_URL=https://portaljs.europeana.eu \
    ANNOTATION_API_URL= \
    ENTITY_API_URL= \
    RECOMMENDATION_API_URL= \
    RECORD_API_URL= \
    SET_API_URL=

RUN mv /docker-entrypoint.sh /docker-entrypoint-nginx.sh && \
    rm -r /usr/share/nginx/html

COPY src .
