desc 'Fix cached counters by reseting them to the correct count, in case they got corrupted somehow'
task :fix_cached_counters => :environment do
  puts "Correcting cached counters: (this may take a few minutes)"
  [ Architecture, Environment, Operatingsystem, Realm].each do |cl|
    cl.unscoped.all.each{|el| cl.reset_counters(el.id, :hosts, :hostgroups)}
    puts "#{cl} corrected"
  end
  Domain.all.each do |el|
    Domain.reset_counters(el.id, :hostgroups)
    el.update_attribute('total_hosts', Nic::Base.primary.where(:domain_id => el.id).count)
  end
  puts "Domains corrected"
  Puppetclass.all.each{|el| Puppetclass.reset_counters(el.id, :lookup_keys)}
  puts "Puppetclass corrected"
  Model.all.each{|el| Model.reset_counters(el.id, :hosts)}
  puts "Model corrected"
  ConfigGroup.all.each{|el| ConfigGroup.reset_counters(el.id, :config_group_classes)}
  puts "ConfigGroup corrected"
  LookupKey.all.each{|el| LookupKey.reset_counters(el.id, :lookup_values)}
  puts "LookupKey corrected"
  Hostgroup.all.each{|el| Hostgroup.reset_counters(el.id, :hosts)}
  puts "Hostgroup corrected"
end

