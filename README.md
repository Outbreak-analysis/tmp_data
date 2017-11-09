**Da**tabase of **t**ime **s**eries of **i**nfectious **d**iseases (Datsid)

Overview
========
This repo provides scripts that can build from scratch a SQLite database. 
The database is built from epidemiological time series (incidence, deaths, etc.) that must be saved in the _correct format_ in the `data` folder. 
There are three main tables (for now) that define the relational database: one that defines the diseases (`table_disease`), one that defines the locations where the epidemic was observed (`table_location`) and finally one that records the epidemic, that is which disease was observed where (`table_epievent`). This last table is automaticaly built.
Information regarding the diseases and the geographical locations must be entered beforehand in these tables.

Structure
========

* `tables` folder with static tables (describing diseases, locations, etc.). There are also Excel spreadsheet that facilitates entering new entries in these tables. 
* `data` folder contains the `*-db.csv` files containing the epidemiological data that populates the database.
* the subfolder `data/raw-data` contains the raw data files that were either manually obtained, or downloaded directly from the internet. The file name conventions are
  * `-web.R` script to download data when possible
  * `-raw.csv` for downloaded data (either manually or with `-web.R` script)
  * `-dictionary-*.csv` is human-readable metadata used for substitutions 
  * `-info.csv` some more metadata about the raw data file
  * `-reformat.R` converts input csvs to final version:
  * `-db.csv` formated data ready for import into the database. These files are copied in the `data` folder.
* `sql` folder contains SQL scripts.

__TODO__:
* Incorporate this into make, or otherwise make transparent

Tables
=============

To add entries in `table_location`:
* Enter the new data in the spreadsheet `table_location_data.xlsm` and execute the macro
* or (__not suggested__) , edit directly the file `table_location_data.csv`

The script `create_table_location.R` will create the final table `table_location.csv` for the database.

Synthetic Data
==============

Synthetic epidemic time series (generated by mathematical models) can be included in the database. They have the same format as real ones. The field `synthetic` in `table_epievent` allow to distinguish real from synthetic epidemics: `synthetic=0` means a real epidemic data. `synthetic=n` means it is the nth stochastic realization of a mathematical model.

The script `gen-syndata` in `data/synthetic` generates synthetic data from a SEmInR stochastic model. The model parameters (e.g. R0, etc) need to be changed directly in the script (for now, will change that); several parameter sets can be simulated at once. The synthetic data generated (`syn-data.csv`) have the correct format, ready to be imported in the database.
Running `gen-syndata n` will generate `n` stochastic realizations for each parameter sets.

Using the database in R
=======================

The program `buildDBfromScratch.sh abc.db` will download the raw data from the internet (scan and execute all `*-webR` scripts in the folder `data/raw-data`) and use raw data (manually saved if no `*-web.R` script exists) to create a new database named `abc.db`. 
Note: `abc.db` must not already exist.

The program `buildNewDB.sh` builds a new database from the _existing_ `data/*-db.csv` files. In other words, the datasets are not downloaded nor reformated.

Running `glimpse abc.db` gives a summary of the data in the database `abc.db`.

