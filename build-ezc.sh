#!/bin/bash
cd /tmp/ && curl https://github.com/ChemicalDevelopment/ezc/archive/master.zip -L > ezc.zip && unzip -o ezc.zip && cd ezc-master && make install