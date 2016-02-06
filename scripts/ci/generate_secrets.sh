#! /bin/sh

## This file is kept around in case you don't want the secret key being kept
## in an environment variable. If this is the case, then uncomming the following
## lines and make sure to have the secret key set at build time.


# template=`cat config/prod.secret.exs.tpl`
# key=$SECRET_KEY_BASE

# echo "$template" | awk -v KEY="$key" '{gsub(/SECRET_KEY_BASE/, KEY); print}' > config/prod.secret.exs
