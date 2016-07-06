# mailman3

Dockerfile and configuration as applicable for the OSF.

> #### Incomplete

> - Move postgres to an external container
> - Consolidate configuration options for mailman3, mailman-bundler, and postfix

## Information

This container is configured here por production.
- Mailman is set up to use gunicorn as the WSGI server.

## Setup

- Ensure docker and docker-compose are configured and installed correctly
- `# docker-compose up`
- To run in the background, wait until the server is running, and then `^C`,
- `# docker-compose start`



