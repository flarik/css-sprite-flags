#!/usr/bin/env ruby

#
# Generate css image sprite of flags with pirates
# 
# Author: Frodo Larik 
#

# Warning: Read through this file to understand what it's doing
#
#
# You need
# - Ruby
# - ImageMagick (montage)
# - PngCrush
#
# e.g. Install on mac os x with MacPorts
#
# $ sudo port install ImageMagick 
# $ sudo port install pngcrush
#
#
# You also need an directory with images ordered like this:
#
#   input_dir/icon_size 1/*.png
#   input_dir/icon_size_2/*.png
#   input_dir/icon_size_3/*.png
#
# Flags can be obtained from: 
# https://www.gosquared.com/resources/flag-icons/


# Dir containing the icons
input_dir        = '/Users/x/flags/flags-iso/flat'
icon_sizes       = [ 16, 24, 32, 48, 64 ]
output_base_dir  = '~/css-sprite-flags/assets'

# Cannot work with input dir
if !File.exists?(input_dir)
  puts "#{input_dir} does not exist!"
  exit
end


def file_exists?(file)
  if File.exists?(file)
    puts "#{file} already exists, please remove!"
    return true
  end
  false
end

def normalize_name(png)
  png.gsub(/\.png$/i,'').gsub(/^_/,'').downcase
end

#
# Create matrix containing the flag names
# This matrix is build the same like the montage tool from ImageMagick does
#
def create_matrix(pngs)
  matrix           = []
  matrix_row       = []
  matrix_row_index = 0
  columns = Math.sqrt(pngs.size).ceil

  pngs.each_with_index do |png,index|
    name = normalize_name(png)
    matrix_row << name

    if (index+1).modulo(columns) == 0
      matrix[matrix_row_index] = matrix_row
      matrix_row               = []
      matrix_row_index         += 1
    end
  end

  matrix
end


icon_sizes.each do |icon_size|

  # Dir containing the icons of this specific size
  Dir.chdir(File.join(input_dir, icon_size.to_s))

  pngs                = Dir.glob("*.png")
  xy                  = "#{icon_size}x#{icon_size}"
  output_dir          = File.join(output_base_dir, xy) 
  output_tmp_png      = File.join('/tmp/',"sprite-#{icon_size}.png")
  output_png_filename = "sprite-flags-#{xy}.png"
  output_png          = File.join(output_dir, output_png_filename)
  output_css_filename = "sprite-flags-#{xy}.css"
  output_css          = File.join(output_dir, output_css_filename)
  output_html         = File.join(output_dir,"index.html")

  File.unlink(output_tmp_png) if file_exists?(output_tmp_png)
  File.unlink(output_png)     if file_exists?(output_png) 
  Dir.mkdir(output_dir)       unless file_exists?(output_dir)


  # ImageMagick -> create actual sprite image
  system("montage -background transparent -geometry +0+0 #{pngs.join(' ')} #{output_tmp_png}")

  # Pngcrush -> crush the png
  system("pngcrush -rem allb -brute -reduce #{output_tmp_png} #{output_png}")

  # Create CSS

  css = <<-EOCSS
  .flag { 
    display: inline-block; 
    background-repeat: no-repeat;
  }

  .flag.flag-#{icon_size} { 
      display: inline-block; 
      width: #{icon_size}px;
      height: #{icon_size}px;
      background-image: url('#{output_png_filename}'); 
      background-repeat: no-repeat;
   }
  EOCSS

  matrix = create_matrix(pngs)

  matrix.each_with_index do |row,row_index|
    top = row_index*icon_size
    row.each_with_index do |col,col_index|
      left = col_index*icon_size
      css << ".flag.flag-#{icon_size}.flag-#{col} { background-position: -#{left}px -#{top}px; }\n"
    end
  end

  File.open(output_css,'w') do |f|
    f.write(css)
  end

  html = <<-EOHTML
    <!doctype html>
    <html>
    <head>
      <title>CSS Sprite Flags #{xy}</title>
      <link rel="stylesheet" href="#{output_css_filename}" />
      <style type="text/css">
        body { font: #{icon_size}px/1 Helvetica }
      </style>
    </head>
    <body>
    <h1>CSS Sprite Flags #{xy}</h1>
  EOHTML

  pngs.each do |png|
    name = normalize_name(png)
    html << "<i class=\"flag flag-#{icon_size} flag-#{name}\"></i> #{name}<br />\n"
  end

  html << <<-EOHTML
    </body>
    </html>
  EOHTML

  File.open(output_html,'w') do |f|
    f.write(html)
  end

end

