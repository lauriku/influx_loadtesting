#!/usr/bin/env python 
# A quick and dirty script to generate testdata to a file,
# to be used by the Locust write test

from __future__ import division
import random

measurements = ['temperature', 'humidity', 'co', 'co2', 'motor', 'airflow', 'pressure']

n=0
while n < 250:
  for measurement in measurements:
    f = open('generated_testdata.txt', 'a')
    random_device_id = str(random.randint(30000, 31000))
    random_value = str(random.randint(1000, 3000) / 100)
    f.write(measurement + ",device_id=" + random_device_id + " value=" + random_value + "\n")
    n = n+1
