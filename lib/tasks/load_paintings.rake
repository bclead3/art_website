# % rake paintings:rss\[Prints\]
# % rake paintings:rss\[Oceanside\]
# % rake paintings:rss\[Landscape\]
# % rake paintings:rss\[Northshore\]
# % rake paintings:rss\[Winterscape\]
# % rake paintings:rss\[Portraits\]
# % rake paintings:rss\[Oceanside\]

# http://sleadholm.com/Site/Journal/Entries/2017/4/2_Winters_End_at_Artists_Point.html

   #<Painting id: nil,
            # page_position: nil,
            # name: nil,
# background: nil,
# timestamp: nil.
            # price: nil,
            # is_sold: nil,
# width: nil,
# height: nil,
# category_id: nil,
# type_id: nil
            # image: nil,
            # blob_thumbnail: nil,
            # blob_micro: nil,
            # img_url: nil,
            # created_at: nil,
            # updated_at: nil
            # >"

namespace :paintings do
  category_h = {
    Prints: 'http://www.sleadholm.com/Site/Prints_files/rss.xml',
    Oceanside: 'http://www.sleadholm.com/Site/Oceanside_files/rss.xml',
    Landscape: 'http://www.sleadholm.com/Site/Landscape_files/rss.xml',
    Northshore: 'http://www.sleadholm.com/Site/Northshore_files/rss.xml',
    Winterscape: 'http://www.sleadholm.com/Site/Winterscape_files/rss.xml',
    Portraits: 'http://www.sleadholm.com/Site/Portraits_files/rss.xml',
    Journal: 'http://www.sleadholm.com/Site/Journal/rss.xml'
  }

  TMP_PATH  = "#{Rails.root}/public/uploads/tmp"

  # rake paintings:rss\[Landscape\]
  desc 'Take paintings from RSS and public/Media and populate the Painting database table'
  task :rss, [:category] => [:environment] do |t, args|
    # puts "args #{args.inspect}"
    puts "category:#{args[:category]}"
    cat_sym = args[:category]&.to_sym
    url = category_h[cat_sym]
    # puts "url:#{url}"
    cat_id = Category.find_by(name: args[:category])&.id || Category.find_by(name: args[:category].pluralize)&.id
    puts "cat_id :#{cat_id}"
    type_id = Type.find_by(name: args[:category].singularize)&.id || 1
    puts "type_id:#{type_id}"
    temp_temp_path  = "#{Rails.root}/public/uploads/tmp/#{args[:category]}"
    if ! Dir.exist?(temp_temp_path)
      puts "creating folder of category #{args[:category]}"
      Dir.mkdir(temp_temp_path) unless Dir.exist?(temp_temp_path)
    end

    doc = Nokogiri::XML(URI.open(url))
    dir_name = doc.xpath('/rss/channel/title').children.first.content

    if dir_name == 'My Photos'
      dir_name = 'Northshore'
    end

    items = doc.xpath('//item')

    items.each_with_index do |item, category_index|
      title_arr = item.at_xpath('title').content.split("\n").select{|x| !x.blank?}.map{|x| x.gsub(/\s\s/, ' ') }
      p title_arr
      # p "title array size:#{title_arr.size}"
      # str.scan(/((\d+)(”|\"|’))/
      title = title_arr.first.strip.size.positive? ? title_arr.first.gsub(/\s\s/, ' ').gsub('/', '-') : title_arr[1].gsub(/\s\s/, ' ').gsub('/', '-')
      size = title_arr.select{ |x| x.index('x') && (x.index('”') || x.index('"') || x.index('’')) }.empty? ? nil : title_arr.select{ |x| x.index('x') && (x.index('”') || x.index('"')) }
      puts "size:#{size}"

      is_sold = title_arr.select{ |x| x.downcase.index('sold') }.empty? ? false : true
      url = item.at_xpath('enclosure').attribute('url').value
      file_type = url.split('.').pop
      thumbnail = item.at_xpath('iphoto:thumbnail').children.first.content
      micro = item.at_xpath('iweb:micro').children.first.content
      meta = item.at_xpath('iweb:richTitle')
      sub_doc = Nokogiri::XML(meta)

      new_title = nil
      itmz = sub_doc.css('div div p.Caption').select{|x| !x.text.blank?}

      itmz.each_with_index do |sub_item, itm_indx|
        p "#{itm_indx} #{sub_item.text}"
        p "#{itm_indx} #{sub_item.text.gsub(/\s\s/, ' ')}"
        if itm_indx.zero? && sub_item.text != 'sold'
          new_title = sub_item.text.gsub(/\s\s/, ' ').strip
        elsif itm_indx >= 1 && sub_item.text.index('x') && (sub_item.text.index('”') || sub_item.text.index('"') || sub_item.text.index('’'))
          size = sub_item.text
        elsif itm_indx >= 1 && sub_item.text.match(/((\d+)(”|\"|’))/)
          size = sub_item.text
        elsif itm_indx >= 1 && sub_item.text.downcase.index('sold')
          is_sold = true
        elsif itm_indx.zero? && new_title.blank? && sub_item.text == 'sold' && title != 'sold'
          new_title = title
        elsif new_title.blank? && sub_item.text == 'sold' && title == 'sold'
          new_title = 'Mineopa Creek in Winter'
        elsif new_title.blank? && title.blank?
          new_title = 'Mineopa Creek in Winter'
        elsif !new_title.blank?
          new_title += sub_item.text.gsub(/\s\s/, ' ').strip
        end
      end
      #new_title = title if new_title.blank?
      new_title = new_title
                    .gsub(/\s\s/, ' ')
                    .gsub(',', ' ')
                    .gsub(/\s\s/, ' ')
                    .gsub('/', '_')
                    .gsub(' ', '_')
                    .strip

      file_name = "#{new_title}.#{file_type}"
      height = nil
      width = nil
      unless size.blank?
        # puts "size is:#{size}"
        if size.is_a?(Array)
          out = size.first.scan(/((\d+)(”|\"|’))/)
        elsif size.is_a?(String)
          out = size.scan(/((\d+)(”|\"|’))/)
        end
        height = out.first[1]
        width = out.last[1]
        puts "h:#{height} w:#{width}"
      end

      p "old title:#{title.strip}"
      p "new title:#{new_title}"
      p "file type:#{file_type}"
      p "file name:#{file_name}"
      p "size:#{size}" unless size.nil?
      p "is_sold:#{is_sold}"
      p "url:#{url}"
      p "thumbnail:#{thumbnail}  micro:#{micro}"
      new_file_name = "#{title.strip}.#{file_type}"
      p "new file :#{new_file_name}"
      # p "meta: #{meta.to_s.html_safe}"

      painting_params_h = {
        page_position: (category_index + 1),
        name: title.strip,
        background: url,
        is_sold: is_sold,
        category_id: cat_id,
        type_id: type_id
      }
      unless height.nil?
        painting_params_h.merge!( height: height.to_i )
      end
      unless width.nil?
        painting_params_h.merge!( width: width.to_i )
      end

      pp painting_params_h

      p "processing #{dir_name}/#{new_file_name}"

      painting = Painting.find_or_create_by(painting_params_h)
      pp painting.inspect

      temp_file_path = File.join(temp_temp_path, new_file_name)
      puts "temp_file_path:#{temp_file_path}"
      obj = URI.open(url)
      size_one = obj.size
      puts "obj inspect:#{obj.inspect}"
      puts "obj size   :#{size_one}"

      size = File.open(temp_file_path, 'wb') do |t_f|
        t_f.binmode
        t_f.write(obj.read)
      end
      puts "temp_filesize:#{size}"

      full_temp_file = File.open(temp_file_path, 'r')

      painting.image = full_temp_file
      painting.save

      p "#{category_index}--------------------"
    end
  end

  # rake paintings:load_from_media\[Landscape\]
  desc 'Take paintings from public/Media and populate the Painting database table'
  task :load_from_media, [:category] => [:environment] do |t, args|
    puts "args #{args}"
    puts "category:#{args[:category]}"
    puts "Paintings count is #{Painting.count}"
  end

  # rake paintings:load_from_journal
  desc 'Take paintings from public/Media and populate the Painting database table'
  task :load_from_journal, [:category] => [:environment] do |t, args|

    puts "args #{args}"
    puts "category:#{args[:category]}"
    puts "Paintings count is #{Painting.count}"

    url       = 'http://sleadholm.com/Site/Journal/blog-archive.xml'
    doc       = Nokogiri::XML(URI.open(url))

    #uri_parser = URI::Parser.new
    doc.css('item').each_with_index do |elements, journal_index|
      title = elements.css('title').children.text
      link = elements.css('link').children.text
      date_str = elements.css('pubDate').children.text
      dt = DateTime.parse(date_str)
      puts "title:#{title}"
      puts "link:#{link}"
      puts "dt  :#{dt.iso8601}"

      painting_h = {
        name: title,
        page_position: (journal_index + 1),
        timestamp: dt.iso8601,
        category_id: 1, #Journal
        type_id: 1      #Painting
      }
      painting = Painting.new(painting_h)

      doc2 = Nokogiri::XML(URI.open(link))
      painting_history = doc2.css('#body_layer .style_SkipStroke_2 .text-content .style p.Body').children&.first&.content
      if painting_history.nil?
        painting_history = doc2.css('#body_layer .text-content .style p').children&.first&.content
      end
      puts "hist:#{painting_history}"

      painting.background = painting_history

      image_src = doc2.css('.tinyText img#generic-picture-attributes').attribute('src').value
      image_type = image_src.split('.').last
      temp_img_src = image_src.gsub('/', '_')
      image_src = Addressable::URI.parse(image_src)

      puts "src :#{image_src}"
      puts "type:#{image_type}"
      link_arr = link.split('/')
      link_arr.pop
      link_arr.push(image_src)
      link_url = link_arr.join('/')
      puts "link_url :#{link_url}"

      temp_file_path = File.join(TMP_PATH, temp_img_src)
      puts "temp_file_path:#{temp_file_path}"
      obj = URI.open(link_url)
      puts "obj inspect:#{obj.inspect}"
      puts "obj size   :#{obj.size}"

      size = File.open(temp_file_path, 'wb') do |t_f|
        t_f.binmode
        t_f.write(obj.read)
      end
      puts "temp_file_temp size:#{size}"

      full_temp_file = File.open(temp_file_path, 'r')

      painting.image = full_temp_file
      puts 'about to save to make uploaded thumbnails'
      painting.save!
      p painting

      puts '--------------'
    end

  end

  desc 'Take paintings from public/Media and populate the Painting database table'
  task :uploads_reset do |t, args|
    puts "args #{args}"
    cat_arr = %w[Journal Landscapes Northshore Oceanside Portraits Prints Winterscapes]
    cat_arr.each do |cat_name|
      puts "Clearing files from #{cat_name} directory"
      FileUtils.rm_r( Dir.glob("#{Rails.root}/public/uploads/image/painting/#{cat_name}/**/**"), force:true, secure:true )
    end
  end

  desc 'Transfer paintings table from development to production'
  task :transfer, [:category] => [:environment] do |r, args|
    puts "args:#{args}"
    # cat_arr = Category.all.map(&:name)
    cat_arr = %w[Journal Winterscapes Oceanside Prints Landscapes Northshore Portraits]
    h = {}
    cat_arr.each do |cat_name|
      h[cat_name] = {}
      cat_id = Category.where(name: cat_name).first.id
      p_arr = Painting.where(category_id: cat_id).all
      p_arr.each do |p_obj|
        id_str = p_obj.id.to_s
        h[cat_name][id_str] = {}
        h[cat_name][id_str]['id'] = p_obj.id
        h[cat_name][id_str]['page_position'] = p_obj.page_position
        h[cat_name][id_str]['name'] = p_obj.name
        h[cat_name][id_str]['background'] = p_obj.background
        h[cat_name][id_str]['date'] = p_obj.date
        h[cat_name][id_str]['timestamp'] = p_obj.timestamp&.iso8601
        h[cat_name][id_str]['is_sold'] = p_obj.is_sold
        h[cat_name][id_str]['width'] = p_obj.width
        h[cat_name][id_str]['height'] = p_obj.height
        # h[cat_name][id_str]['image'] = p_obj.image
        h[cat_name][id_str]['image_path'] = p_obj.image.file.file
        h[cat_name][id_str]['image_filename'] = p_obj.image.identifier
        h[cat_name][id_str]['category_id'] = p_obj.category_id
        h[cat_name][id_str]['type_id'] = p_obj.type_id
      end
    end
    pp h
  end
end



require 'fileutils'
