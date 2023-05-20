module ApplicationHelper

  DIRECTORY_LIST_ARRAY = %w[Landscapes Northshore Oceanside Portraits Prints Winterscapes].freeze
  DIRECTORY_HASH = {
    Ideal: {href: '/home', title: 'Bio / Ideal' },
    Galleries: { href: '/galleries', title: 'Galleries' },
    Prints: { href: '/prints', title: 'Prints', dir: '/Prints' },
    Northshore: { href: '/northshore', title: 'Northshore', dir: '/Northshore' },
    Landscape: { href: '/landscapes', title: 'Landscapes', dir: '/Landscape'},
    Landscapes: { href: '/landscapes', title: 'Landscapes', dir: '/Landscape'},
    Oceanside: { href: '/oceanside', title: 'Oceanside', dir: '/Oceanside' },
    Portraits: { href: '/portraits', title: 'Portraits', dir: '/Portraits' },
    Winterscapes: { href: '/winterscapes', title: 'Winterscapes', dir:'/Winterscaptes' }
  }

  # Types are :full, :micro, :mini, or :thumb
  def retrieve_file_array(category_name, type = :full)
    painting_arr = []
    file_arr = []
    puts "category_name:#{category_name}"
    return [file_arr, painting_arr] unless DIRECTORY_LIST_ARRAY.index(category_name)

    painting_arr = retrieve_paintings_by_category(category_name)
    if %i[micro mini thumb].member?(type)
      file_arr = strip_root_with_version(painting_arr, type)
    elsif type == :full
      file_arr = strip_root(painting_arr)
    end
    [ file_arr, painting_arr ]
  end

  def retrieve_paintings_by_category(category_name)
    Painting.includes(:category).where(category_id: Category.where(name: category_name)&.first&.id )
  end

  def generate_menu(optional_dir_name = nil)
    ret_str = "<div class='menu-ideal'><a href='/home'>Bio / Ideal</a></div>"
    ret_str += "<div class='menu-galleries'><a href='/galleries'>Galleries</a></div>"

    # ret_str += "<div class='menu-prints'><a href='/prints'>Prints</a></div>"
    unless optional_dir_name.nil?
      DIRECTORY_LIST_ARRAY.each do |dir|
        unless optional_dir_name.downcase == dir.downcase
          h = DIRECTORY_HASH[dir.to_sym]
          ret_str += "<div class='menu-#{dir.downcase} lower'><a href='#{h[:href]}'>#{h[:title]}</a></div>"
        end
      end
    end
    ret_str.html_safe
  end

  def generate_carousel_array(category)
    painting_arr = retrieve_paintings_by_category(category)
    ret_str = ''
    i = 0
    while(i < painting_arr.length)
      i += 1
      ret_str += "<span class='dot' data='#{i}'></span>"
    end

    painting_arr.each_with_index do |painting, p_index|
      ret_str += "<div class='carousel-item #{p_index.zero? ? 'active' : ''}'>"
      ret_str += "<img class='d-block' src='#{strip_early_dirs(painting.image.file.file)}' alt='#{painting.name}'>"
      ret_str += "<div class='carousel-caption d-none d-md-block'>"
      ret_str += "<h5>#{painting.name}</h5></div></div>"
    end

    ret_str.html_safe
  end

  private

  def strip_early_dirs(filename)
    return '' if filename.blank?

    arr = filename.split('/')
    i = 0
    dirname = ''
    while (dirname != 'public')
      dirname = arr.shift
    end
    arr.join('/')
  end

  def strip_root_with_version(arr, type)
    ret_arr = arr.map do |x|
      filename = x.image.versions[type].file.file
      filename.slice! (Rails.root.to_s + '/public')
      filename
    end
    ret_arr
  end

  def strip_root(arr)
    ret_arr = arr.map do |x|
      filename = x.image.file.file
      filename.slice! (Rails.root.to_s + '/public')
      filename
    end
    ret_arr
  end
end
