# Performance testing InfluxDB with Locust
This repo is simply a collection of files I used for performance testing InfluxDB. It is not well documented, but for the purpose of openness, all files and results are available.
## Files
.
├── README.md         <-- This readme
├── generate_data.py  <-- A python script to generate random testdata for the Locust task
├── locustfile.py     <-- The main Locust file containing the tasks and other code needed to run Locust
├── plots.r           <-- Some R examples used for generating plots from the test results
├── requirements.txt  <-- pip requirements file
└── results           <-- Folder for the results. CSV files from Locust + sar->sadf exports from system statistics
