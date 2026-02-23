FROM registry.gitlab.com/escape-ossr/eossr:v2.2.0

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make it executable
RUN chmod +x /entrypoint.sh

# Set the working directory to /github/workspace (GitHub Actions default)
WORKDIR /github/workspace

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
