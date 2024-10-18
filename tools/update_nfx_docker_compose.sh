#!/bin/sh

### Prereqs:
##  1. Freqtrade setup to run via docker-compose
##  2. A directory with the NFI repo with the NFI master branch

### Simple script that does the following:
## 1. Pulls latest NFI Repo
## 2. Copies updated NFIX sxtrategy file to Freqtrade
## 3. Optionally Commits the update strategy to a local repo
## 4. Stops, Build, and Start freqtrader via docker-compose
# update_nfx_docker_compose.sh
NFI_REPO_HOME=/root/freqtrade/NostalgiaForInfinity
FREQTRADE_HOME=/root/freqtrade/
COMMIT_TO_LOCAL_REPO=true
#pull latest NFIX strategy and copy to freqtrade
echo "updating NFO Strategy"
cd $NFI_REPO_HOME
git pull
cp NostalgiaForInfinityX5.py $FREQTRADE_HOME/user_data/strategies
echo "copied NFI Strategy to freqtrader"

#optionally add the update strategy file to your own repo
if [ "$COMMIT_TO_LOCAL_REPO" = true ] ; then
    echo 'Commiting updates to local repo'

    #ensure local repo to up to date
    echo "added updates strategy to git"
    cd $FREQTRADE_HOME
    git pull

    #commit update strategy file to local repo
    cd $FREQTRADE_HOME/user_data/strategies
    NFIversion=$(grep -oP '(?<=return ").*(?=")' NostalgiaForInfinityX5.py)
    echo $NFIversion
    git add NostalgiaForInfinityX5.py
    git commit -m "update: updated nfix strategy to version $NFIversion"
    git push

fi

#build and start via docker compose
echo "Starting freqtrade with NFIX"
docker-compose stop
docker-compose build
docker-compose up -d
