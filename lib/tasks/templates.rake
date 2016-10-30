namespace :templates do
  desc 'Import templates from sub-folders'
  task :import, [:folder, :admin_id, :is_premium] => :environment do |t, args|
    admin = Account.find(args[:admin_id])
    raise "Not admin: #{args[:admin_id]}" unless admin.has_role? :admin

    if args[:is_premium] == 'true'
      args[:is_premium] = true
    elsif args[:is_premium] == 'false'
      args[:is_premium] = false
    else
      raise "Not true/false: #{args[:is_premium]}"
    end
    puts args.inspect

    stat = Template.import_from_subfolders(args[:folder], admin, args[:is_premium])
    puts stat.inspect
  end
end
