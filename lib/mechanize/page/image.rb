##
# An image element on an HTML page

class Mechanize::Page::Image
  attr_reader :node
  attr_accessor :page
  attr_accessor :mech

  ##
  # Creates a new Mechanize::Page::Image from an image +node+ and source
  # +page+.

  def initialize node, page
    @node = node
    @page = page
    @mech = page.mech
  end

  ##
  # The src attribute of the image

  def src
    node['src']
  end

  ##
  # The width attribute of the image

  def width
    node['width']
  end

  ##
  # The height attribute of the image

  def height
    node['height']
  end

  ##
  # The alt attribute of the image

  def alt
    node['alt']
  end

  ##
  # The title attribute of the image

  def title
    node['title']
  end

  ##
  # The id attribute of the image

  def dom_id
    node['id']
  end

  ##
  # The class attribute of the image

  def dom_class
    node['class']
  end

  ##
  # The caption of the image.  In order of preference, the #title, #alt, or
  # empty string "".

  def caption
    title || alt || ''
  end

  alias :text :caption

  ##
  # The suffix of the #url. The dot is a part of suffix, not a delimiter.
  #
  #   p image.url     # => "http://example/test.jpg"
  #   p image.extname # => ".jpg"
  #
  # Returns an empty string if #url has no suffix:
  #
  #   p image.url     # => "http://example/sampleimage"
  #   p image.extname # => ""

  def extname
    return nil unless src

    File.extname url.path
  end

  ##
  # MIME type guessed from the image url suffix
  #
  #   p image.extname   # => ".jpg"
  #   p image.mime_type # => "image/jpeg"
  #   page.images_with(:mime_type => /gif|jpeg|png/).each do ...
  #
  # Returns nil if url has no (well-known) suffix:
  #
  #   p image.url       # => "http://example/sampleimage"
  #   p image.mime_type # => nil

  def mime_type
    suffix_without_dot = extname ? extname.sub(/\A\./){''}.downcase : nil

    Mechanize::Util::DefaultMimeTypes[suffix_without_dot]
  end

  ##
  # URI for this image

  def url
    if relative? then
      if page.bases[0] then
         page.bases[0].href + src
      else
        page.uri + src
      end
    else
      src
    end
  end

  ##
  # The URL string of this image

  def to_s
    url.to_s
  end

  ##
  # Downloads the image.
  #
  #   agent.page.image_with(:src => /logo/).fetch.save
  #
  # The referer is:
  #
  # #page("parent") ::
  #   all images on http html, relative #src images on https html
  # (no referer)    ::
  #   absolute #src images on https html
  # user specified  ::
  #   img.fetch(nil, my_referer_uri_or_page)

  def fetch(parameters = [], referer = nil, headers = {})
    mech.get(src, parameters, referer || image_referer, headers)
  end

  def image_referer # :nodoc:
    http_page  = page.uri && page.uri.scheme == 'http'
    https_page = page.uri && page.uri.scheme == 'https'

    case
    when http_page               then page
    when https_page && relative? then page
    else
      Mechanize::File.new(nil, { 'content-type' => 'text/plain' }, '', 200)
    end
  end

  def relative? # :nodoc:
    %r{^https?://} !~ src
  end

  ##
  # Fetches the file and saves it to the given +path+.
  #
  #   page.images_with(:src => /img/).each{|img| img.save}

  def save(path = nil, parameters = [], referer = nil, headers = {})
    fetch(parameters, referer, headers).save(path)
  end

  ##
  # Saves the image to the given +path+ with Mechanize#transact.
  #
  #   p agent.page.uri.to_s # => "http://example/images.html"
  #   agent.page.images[0].download
  #   p agent.page.uri.to_s # => "http://example/images.html"

  def download(path = nil, parameters = [], referer = nil, headers = {})
    mech.transact{ save(path, parameters, referer, headers) }
  end

  def pretty_print(q) # :nodoc:
    q.object_group(self) {
      q.breakable; q.pp url
      q.breakable; q.pp caption
    }
  end

  alias inspect pretty_inspect # :nodoc:

end

