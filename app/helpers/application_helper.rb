module ApplicationHelper

  DIRECTORY_LIST_ARRAY = %w[Landscape Northshore Oceanside Portraits Prints Winterscapes].freeze
  DIRECTORY_HASH = {
    Ideal: {href: '/home', title: 'Bio / Ideal' },
    Galleries: { href: '/galleries', title: 'Galleries' },
    Prints: { href: '/prints', title: 'Prints', dir: '/Prints' },
    Northshore: { href: '/northshore', title: 'Northshore', dir: '/Northshore' },
    Landscape: { href: '/landscapes', title: 'Landscapes', dir: '/Landscape'},
    Oceanside: { href: '/oceanside', title: 'Oceanside', dir: '/Oceanside' },
    Portraits: { href: '/portraits', title: 'Portraits', dir: '/Portraits' },
    Winterscapes: { href: '/winterscapes', title: 'Winterscapes', dir:'/Winterscaptes' }
  }

  def retrieve_file_array(dir_name)
    full_painting_arr = []
    if DIRECTORY_LIST_ARRAY.index(dir_name)
      Dir.glob("public/Media/#{dir_name}/*.jpg") do |f|
        unless f.index('-micro.') || f.index('-thumbnail.')
          full_painting_arr << f.gsub('public', '')
        end
      end
      full_painting_arr
    end
  end

  def generate_menu(optional_dir_name = nil)
    ret_str = "<div class='menu-ideal'><a href='/home'>Bio / Ideal</a></div>"

    if optional_dir_name.nil?
      ret_str += "<div class='menu-galleries'><a href='/galleries'>Galleries</a></div>"
      ret_str += "<div class='menu-prints'><a href='/prints'>Prints</a></div>"
    else
      DIRECTORY_LIST_ARRAY.each do |dir|
        unless optional_dir_name.downcase == dir.downcase
          h = DIRECTORY_HASH[dir.to_sym]
          ret_str += "<div class='menu-#{dir.downcase}'><a href='#{h[:href]}'>#{h[:title]}</a></div>"
        end
      end
    end
    ret_str.html_safe
  end
end
