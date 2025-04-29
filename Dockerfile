FROM quay.io/keycloak/keycloak:24.0.1

# Copy custom themes and realm configurations
COPY ./docker/keycloak/themes/ /opt/keycloak/themes/
COPY ./docker/keycloak/realms/ /opt/keycloak/data/import/

# Set environment variables
# Password should be configured in Azure App Service settings for better security
ENV KC_HTTP_PORT=8181 \
    KEYCLOAK_ADMIN=admin

# Expose the port
EXPOSE 8181

# Set the health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:8181/health || exit 1

# Start Keycloak in development mode with realm import
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--import-realm", "--health-enabled=true"]
