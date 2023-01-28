# Expplit

Expplit is a finance application that helps people to share their expenses.

## Run
To run expplit you can use the neo4j database. You can run the script below:

```bash 
 docker run -d --name=<container-name> --publish=7474:7474 --publish=7687:7687 --publish=7473:7473 --volume=<local-folder>:<container-folder> --env=NEO4J_ACCEPT_LICENSE_AGREEMENT=yes neo4j

```

Next you need to enter in `localhost:7474` and login. As explained in [dockerhub doc](https://hub.docker.com/_/neo4j) your login credentials are neo4j/neo4j. Once you login, it ask you to change the password.

Finally, you need to configure your environment variables (`DB_HOST, DB_USER, DB_PASS`) to let the app access to neo4j database. Once there are configure you must run the app with de command `rails s`.

