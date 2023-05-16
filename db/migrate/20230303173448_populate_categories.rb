class PopulateCategories < ActiveRecord::Migration[7.0]
  def self.up
    %w[Journal Landscapes Northshore Oceanside Portraits Prints Winterscapes].each do |category|
      cat = Category.find_or_create_by(name: category)
      cat.save!
      p cat
    end
  end

  def self.down
    Category.delete_all
  end
end
