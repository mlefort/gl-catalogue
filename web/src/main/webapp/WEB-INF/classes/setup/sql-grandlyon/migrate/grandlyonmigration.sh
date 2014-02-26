# Usage: ./grandlyon-migration.sh www-data db_1044 server port password

function showUsage
{
  echo -e "\nThis script is used to migrate grandlyon from 2.7.1 to 2.11.0"
  echo -e "Usage: ./`basename $0 $1` username database server port password"
}

if [ $# -lt 4 ]
then
  showUsage
  exit
fi

if [ "$1" = "-h" ]
then
        showUsage
        exit
fi

export PGPASSWORD=$5
psql -U $1 -h $3 -p $4 -f run.sql $2 -L log-$2-query.log -o log-$2.log


