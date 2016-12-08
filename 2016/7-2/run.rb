#!/usr/bin/env ruby

def find_fields(ip)
  chunks = ip.split(/[\[\]]/).each_slice(2).to_a
  chunks[-1] << ''
  chunks.transpose
end

def find_abas(supernets)
  supernets.flat_map { |x| x.scan(/(?=(\w)(?!\1)(\w)\1)/) }
end

ips = File.readlines('input').map(&:chomp)

ips.select! do |ip|
  supernets, hypernets = find_fields(ip)
  find_abas(supernets).any? do |outer, inner|
    chunk = inner + outer + inner
    hypernets.any? { |x| x =~ /#{chunk}/ }
  end
end

p ips.size
