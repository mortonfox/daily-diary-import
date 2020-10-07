# daily-diary-import

## Introduction

This is a script that takes a CSV file from the [Libra Android app](https://play.google.com/store/apps/details?id=net.cachapa.libra&hl=en_US) and imports it to the "How much do you weigh today?" question on [DailyDiary](https://www.dailydiary.com/).

The script uses [Ferrum](https://github.com/rubycdp/ferrum) to submit the data by controlling a headless browser via the [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/). Therefore you also need a Chrome or Chromium installation.

## Installation

You need Ruby and either Chrome or Chromium, of course.

Add the following to a ``.netrc`` file in your home directory:

```
machine dailydiary.com
    login USER
    password PASSWORD
```

Where USER and PASSWORD are your login credentials on DailyDiary.

Then run ``bundle install`` in the root of this project to install the required Ferrum and Netrc gems.

## Usage

First, export the database from Libra and transfer it to the computer.

Then run the script to process the Libra CSV file. For example:

```
bundle exec import.rb Libra.csv 2020-09-01 2020-09-30
```

The first command line argument is the name of the export file from Libra.

The second and third arguments are the start and end dates (inclusive) of the range of data to import into DailyDiary. The export file can contain more data but only the rows in that date range will be processed. This allows you to import any portion of the data that you choose.
