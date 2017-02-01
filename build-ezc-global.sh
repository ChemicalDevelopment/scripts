#!/bin/sh
cd /tmp/ && curl https://github.com/ChemicalDevelopment/ezc/archive/master.zip -L > ezc.zip && unzip -o ezc.zip && cd ezc-master && sudo make global