#!/bin/bash

PLANET_SOURCE=/data/genericrhel6/build/planet-source
PLANET_CONTENT=/data/genericrhel6/build/planet-content
LOCKFILE=/tmp/locks/planet.lock
LOGFILE=/var/log/planet-build-prod.log
PLANETS="planet education mozillaonline bugzilla firefox firefoxmobile webmaker firefox-ux webmademovies planet-de universalsubtitles interns research mozillaopennews l10n ateam projects thunderbird firefox-os releng participation taskcluster mozreview"

case "$1" in
    planet)
        PLANETS="releng ateam planet mozreview projects l10n participation thunderbird research"
        ;;
    universalsubtitles)
        PLANETS="universalsubtitles"
        ;;
    webmademovies)
        PLANETS="webmademovies"
        ;;
    firefox)
        PLANETS="firefox firefox-os firefox-ux firefoxmobile"
        ;;
    planetde)
        PLANETS="planet-de"
        ;;
    bugzilla)
        PLANETS="bugzilla"
        ;;
    mozillaonline)
        PLANETS="mozillaonline"
        ;;
    mozillaopennews)
        PLANETS="mozillaopennews"
        ;;
    taskcluster)
        PLANETS="taskcluster"
        ;;
    webmaker)
        PLANETS="webmaker"
        ;;
    education)
        PLANETS="education"
        ;;
    *)
        echo $"Usage: $0 {planet-name}"
        exit 1
esac

if [ ! -d /tmp/locks ]
then
    mkdir /tmp/locks
fi

if [ -f $LOCKFILE ]; then
    LOCKPID=`cat $LOCKFILE`
    ps $LOCKPID > /dev/null
    if [ $? -eq 0 ]
    then
        exit 0
    else
        echo "stale lockfile found removing"
        rm $LOCKFILE
    fi
fi

date > $LOGFILE
echo $$ > $LOCKFILE
cd $PLANET_SOURCE
git pull >> $LOGFILE 2>&1
cd $PLANET_CONTENT
git pull >> $LOGFILE 2>&1
cd $PLANET_CONTENT/branches
for planet in $PLANETS; do
    cd $PLANET_CONTENT/branches/$planet
    DIR=$(grep ^output_dir config.ini | awk '{print $3}')
    sed -i "s|^cache_directory.*|cache_directory = $DIR\/.cache\/|" $PLANET_CONTENT/branches/$planet/config.ini
    python $PLANET_SOURCE/trunk/planet.py $PLANET_CONTENT/branches/$planet/config.ini
    cd $PLANET_CONTENT/branches
done

# Deploy the site
# /data/genericrhel6/deploy -nq $(grep ^output_dir */config.ini | awk -F '= ' '{print $2}' | awk -F '/' '{print $5}' | sed 's/\r//' | sort -u) >> $LOGFILE 2>&1

rm -f $LOCKFILE
date >> $LOGFILE
echo "Done" >> $LOGFILE
