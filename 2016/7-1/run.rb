#!/usr/bin/env ruby

ips = File.readlines('input').map(&:chomp)
ips.reject! { |x| x =~ /\[\w*(\w)(?!\1)(\w)\2\1\w*\]/ }
ips.select! { |x| x =~ /(\w)(?!\1)(\w)\2\1/ }
puts ips.size
