#!/bin/bash -x
mkdir -p public;echo "<a href='pcsef.log'>LOG</a>" > public/index.html
(
  # Lance les tests
  make clean
  make test.bin
  make test &
  PIDTEST=$!
  sleep 10
  kill $PIDTEST  cp test test_brut
  # Enlève le superflu pour les logs
  cat test | awk 'match($0,/^.*\x1b\[3.m/){print $0}' > test.log
  # Affiche les tests pour le job
  cat test
  cp *.log ../public/
  cp test_brut ../public/
)     
(
  cd public
  # Ajoute la date courante
  date > 0_lastupdate.log
  # Et l'ajoute au log total
  cat *.log | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" > ../pcsef.fulllog
  cp ../pcsef.fulllog pcsef.log
)
