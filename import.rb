#!/usr/bin/env ruby

# frozen_string_literal: true

require 'csv'
require 'date'
require 'ferrum'
require 'netrc'

netrc = Netrc.read
entry = netrc['dailydiary.com']
unless entry
  warn 'Please add a netrc entry for dailydiary.com'
  exit 1
end

user, pass = entry

csvdata = CSV.open('Libra_2020-10-06.csv', 'r', col_sep: ';') { |csv|
  csv.map { |row|
    next if row.size < 2 || row[0].start_with?('#')
    [Date.parse(row[0]), row[1].to_f.round(1)]
  }.compact
}

p csvdata

exit 0

browser = Ferrum::Browser.new
browser.goto('https://www.dailydiary.com/signin')
browser.at_css('#Email').focus.type(user)
browser.at_css('#Password').focus.type(pass)
browser.at_css('#submit_form').click

browser.goto('https://www.dailydiary.com/myquestions/892755/how-much-do-you-weigh-today/answer')
browser.at_css('#AnswerDate').focus.type('10012020')
browser.at_css('#AnswerTime').focus.type('1000A')
browser.at_css('#ValueA').evaluate('this.value = "202.6"')
browser.at_css('#submit_save').click

browser.screenshot(path: 'hello.png')

browser.quit

__END__
