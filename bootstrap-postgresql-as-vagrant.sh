# Edit the following to change the name of the database user that will be created:
# Access this user via
# sudo -i -u postgres psql
# psql -h localhost -U godzilla
# enter APP_DB_PASS when requested

APP_DB_USER=godzilla

# Create a random password each time Vagrant is provisioned
APP_DB_PASS=$(< /dev/urandom tr -dc "[:alnum:]" | head -c20)

# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_NAME=$APP_DB_USER

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=12

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 15432)"
  echo "  Host: localhost"
  echo "  Port: 15432 (default value in Vagranfile)"
  echo "  Database: $APP_DB_NAME"
  echo "  Username: $APP_DB_USER"
  echo "  Password: $APP_DB_PASS"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo -i -u postgres psql"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo -i -u postgres psql"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME"
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME"
}


PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi


export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
if [ ! -f "$PG_REPO_APT_SOURCE" ]
then
  # Add PG apt repo:
  echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > "$PG_REPO_APT_SOURCE"

  # Add PGDG repo key:
  wget --quiet -O - https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
fi

# Update package list and upgrade all packages
apt-get update
apt-get -y upgrade

apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
service postgresql restart


# This EOF-block creates the user as defined above when Vagrant creates this VM
cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

-- Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
EOF

# This EOF-block creates a file that can be run after we log in as vagrant:
# vagrant@ubuntu-focal:~$
#     sudo -i -u postgres
# then import the file as postgres:
# postgres@ubuntu-focal:~$
#     psql -h localhost -U godzilla -f psql_booter.sql
# (Enter password visible in /var/lib/postgresql/password_for_[...])
# Then log in to postgres as godzilla
#     psql -h localhost -U godzilla
# (Enter same password)
cat >> /var/lib/postgresql/psql_booter.sql <<EOF
   CREATE TABLE profile (
     ID SERIAL PRIMARY KEY,
     name VARCHAR(30),
     email VARCHAR(30)
   );
EOF

# insecurely store password until I can figure out how to do it right
cat >> /var/lib/postgresql/password_for_$APP_DB_USER <<EOF
$APP_DB_PASS
EOF

if [ ! -f "/var/lib/postgresql/.bash_history" ]
then
  cat >> /var/lib/postgresql/.bash_history <<EOF
cat /var/lib/postgresql/password_for_$APP_DB_USER
psql -h localhost -U $APP_DB_USER -f psql_booter.sql
psql -h localhost -U $APP_DB_USER
EOF
fi

# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created PostgreSQL dev virtual machine."
echo ""
print_db_usage
