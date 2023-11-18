# Use the official MySQL base image from Docker Hub
FROM mysql:8

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=cp23kk1!_BJY


# Copy SQL scripts to initialize the database
COPY ./initialize.sql/ /docker-entrypoint-initdb.d/
COPY ./load_vocabulary.sql/ /docker-entrypoint-initdb.d/

# Expose the MySQL port
EXPOSE 3306

# The default command to run when the container starts
CMD ["mysqld"]

# Note: In a production environment, you should handle database initialization and configuration securely.
