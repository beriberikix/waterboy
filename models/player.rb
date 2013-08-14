class Player < ActiveRecord::Base

  # Create a Player from posted params.
  def self.from_params(params)
    player = where(uid: params['uid']).first_or_initialize.tap do |p|
      p.name = params['name']
      p.image_url = params['image_url']

      p.save!
    end

    return player
  end

end
