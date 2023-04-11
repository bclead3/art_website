class PopulateTypes < ActiveRecord::Migration[7.0]

  def self.up
    %w[Painting Print Photo Physical].each do |type|
      typ = Type.find_or_create_by(name: type)
      typ.save!
      p typ
    end
  end

  def self.down
    Type.delete_all
  end

end
