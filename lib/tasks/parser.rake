require 'open-uri'

namespace :parse do

	desc "Parse Alachu County Jail"
	task :alachua => :environment do
		url = "http://oldweb.circuit8.org/inmatelist.php"
		doc = Nokogiri::HTML(open(url))
		inmates = []
		
		links = doc.xpath("//a[contains(@href, '/cgi-bin/jaildetail.cgi?bookno=')]")
		links.each do |link|
			name = link.text.strip.split(',')
			href = link['href']
			first_name = name.last.strip
			last_name = name.first.strip
			inmate_name = "#{first_name} #{last_name}"
			bookno = href[31..-1]
			puts "#{inmate_name} #{href} #{bookno}"
		end
		
		puts "alachua test #{inmates.length}"
	end
end
