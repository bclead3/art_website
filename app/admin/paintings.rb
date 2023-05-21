ActiveAdmin.register Painting do
  permit_params :page_position, :name, :background, :timestamp, :price, :is_sold, :width, :height, :category_id, :type_id, :image, :updated_at

  index do
    selectable_column
    id_column
    column :page_position
    column :name
    column :timestamp
    column :price
    column :is_sold
    column :width
    column :height
    column :category
    column :type
    column :image do |painting|
      filename = painting.image.versions[:micro].file.file
      filename.slice! (Rails.root.to_s + '/public')
      image_tag filename
    end
    actions
  end

  filter :page_position
  filter :name
  filter :is_sold
  filter :category

  form do |f|
    f.inputs do
      f.input :page_position
      f.input :name
      f.input :background
      f.input :timestamp, hint: 'Select a date',
        prompt: {day: 'Day', month: 'Month', year: 'Year'},
        start_year: 1980
      f.input :price
      f.input :is_sold
      f.input :width
      f.input :height
      f.input :category
      f.input :type
      f.input :image, required: false, hint: image_tag(object.image.url(:thumb)).html_safe
    end
    f.actions
  end

end