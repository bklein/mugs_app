namespace :jail do
  
  namespace :alachua do
    
    task :setup => :environment do
      
      @alachua = Jails.create(
        :short_name => "alachua_fl",
        :full_name => "Alachua County Jail"
        )
        
      if @alachua.save
        puts "Jail #{@alachua.short_name} | #{@alachua.full_name} created: ID=#{@alachua.id}"
      end
      
    end
    
  end
  
end