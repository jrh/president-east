require "shrine"
require "shrine/storage/s3"

desc "This task is called by the Heroku scheduler add-on DAILY"
task clear_shrine_cache: :environment do
  s3 = Shrine.storages[:cache]
  s3.clear! { |object| object.last_modified < Time.now - 7*24*60*60 } # delete files older than 1 week
end
