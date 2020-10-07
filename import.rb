#!/usr/bin/env ruby

# frozen_string_literal: true

require 'csv'
require 'date'
require 'ferrum'
require 'netrc'

unless ARGV.size >= 3
  warn "Usage: #{$PROGRAM_NAME} csv-file start-date end-date"
  exit 1
end

csvfname = ARGV.shift
startdate = Date.parse(ARGV.shift)
enddate = Date.parse(ARGV.shift)

netrc = Netrc.read
entry = netrc['dailydiary.com']
unless entry
  warn 'Please add a netrc entry for dailydiary.com'
  exit 1
end

user, pass = entry

csvdata = CSV.open(csvfname, 'r', col_sep: ';') { |csv|
  csv.map { |row|
    next if row.size < 2 || row[0].start_with?('#')

    date = Date.parse(row[0])
    next if date < startdate || date > enddate

    [date, row[1].to_f.round(1)]
  }.compact
}

browser = Ferrum::Browser.new
browser.goto('https://www.dailydiary.com/signin')
browser.at_css('#Email').focus.type(user)
browser.at_css('#Password').focus.type(pass)
browser.at_css('#submit_form').click

csvdata.each { |date, value|
  puts "Posting data for #{date} ..."

  browser.goto('https://www.dailydiary.com/myquestions/892755/how-much-do-you-weigh-today/answer')
  browser.at_css('#AnswerDate').focus.type(date.strftime('%m%d%Y'))
  browser.at_css('#AnswerTime').focus.type('1000A')
  browser.at_css('#ValueA').evaluate("this.value = '#{value}'")

  # browser.screenshot(path: 'hello.png')

  browser.at_css('#submit_save').click

  sleep(1)
}

browser.quit

__END__
