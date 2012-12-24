class PusherGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  check_class_collision suffix: "Pusher"
  argument :events, type: :array, default: [:created, :updated, :destroyed], banner: "event event"


  def create_pusher_file
    template 'pusher.rb', File.join('app/pushers', class_path, "#{file_name}_pusher.rb")
  end
end
