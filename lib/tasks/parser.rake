require 'open-uri'
require 'digest'
require Rails.root.join('lib/parsers.rb')
namespace :parse do
  include Parsers::Alachua
 
	desc "Parse Alachu County Jail"
	task :alachua => :environment do
    parse
  end
    
end
