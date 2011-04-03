require 'yaml'

##
# This class is used to manage the Cookies that have been returned from
# any particular website.

class Mechanize::CookieJar

  # add_cookie wants something resembling a URI.

  FakeURI = Struct.new(:host) # :nodoc:

  attr_reader :jar

  def initialize
    @jar = {}
  end

  # Add a cookie to the Jar.
  def add(uri, cookie)
    return unless valid_cookie_for_uri?(uri, cookie)

    normal_domain = cookie.domain.downcase

    unless @jar.has_key?(normal_domain)
      @jar[normal_domain] = Hash.new { |h,k| h[k] = {} }
    end

    @jar[normal_domain][cookie.path] ||= {}
    @jar[normal_domain][cookie.path][cookie.name] = cookie

    cookie
  end

  # Fetch the cookies that should be used for the URI object passed in.
  def cookies(url)
    cleanup
    url.path = '/' if url.path.empty?

    domains = @jar.find_all { |domain, _|
      cookie_domain = self.class.strip_port(domain)
      if cookie_domain.start_with?('.')
        url.host =~ /#{Regexp.escape cookie_domain}$/i
      else
        url.host =~ /^#{Regexp.escape cookie_domain}$/i
      end
    }

    return [] unless domains.length > 0

    cookies = domains.map { |_,paths|
      paths.find_all { |path, _|
        url.path =~ /^#{Regexp.escape(path)}/
      }.map { |_,cookie| cookie.values }
    }.flatten

    cookies.find_all { |cookie| ! cookie.expired? }
  end

  def empty?(url)
    cookies(url).length > 0 ? false : true
  end

  def to_a
    cleanup

    @jar.map do |domain, paths|
      paths.map do |path, names|
        names.values
      end
    end.flatten
  end

  # Save the cookie jar to a file in the format specified.
  #
  # Available formats:
  # :yaml  <- YAML structure
  # :cookiestxt  <- Mozilla's cookies.txt format
  def save_as(file, format = :yaml)
    ::File.open(file, "w") { |f|
      case format
      when :yaml then
        YAML::dump(@jar, f)
      when :cookiestxt then
        dump_cookiestxt(f)
      else
        raise ArgumentError, "Unknown cookie jar file format"
      end
    }
  end

  # Load cookie jar from a file in the format specified.
  #
  # Available formats:
  # :yaml  <- YAML structure.
  # :cookiestxt  <- Mozilla's cookies.txt format
  def load(file, format = :yaml)
    @jar = open(file) { |f|
      case format
      when :yaml then
        YAML::load(f)
      when :cookiestxt then
        load_cookiestxt(f)
      else
        raise ArgumentError, "Unknown cookie jar file format"
      end
    }

    cleanup

    self
  end

  # Clear the cookie jar
  def clear!
    @jar = {}
  end

  # Read cookies from Mozilla cookies.txt-style IO stream
  def load_cookiestxt(io)
    now = Time.now

    io.each_line do |line|
      line.chomp!
      line.gsub!(/#.+/, '')
      fields = line.split("\t")

      next if fields.length != 7

      expires_seconds = fields[4].to_i
      expires = (expires_seconds == 0) ? nil : Time.at(expires_seconds)
      next if expires and (expires < now)

      c = Mechanize::Cookie.new(fields[5], fields[6])
      c.domain = fields[0]
      # Field 1 indicates whether the cookie can be read by other machines at
      # the same domain.  This is computed by the cookie implementation, based
      # on the domain value.
      c.path = fields[2]               # Path for which the cookie is relevant
      c.secure = (fields[3] == "TRUE") # Requires a secure connection
      c.expires = expires             # Time the cookie expires.
      c.version = 0                   # Conforms to Netscape cookie spec.

      add(FakeURI.new(c.domain), c)
    end

    @jar
  end

  # Write cookies to Mozilla cookies.txt-style IO stream
  def dump_cookiestxt(io)
    to_a.each do |cookie|
      fields = []
      fields[0] = cookie.domain

      if cookie.domain =~ /^\./
        fields[1] = "TRUE"
      else
        fields[1] = "FALSE"
      end

      fields[2] = cookie.path

      if cookie.secure == true
        fields[3] = "TRUE"
      else
        fields[3] = "FALSE"
      end

      fields[4] = cookie.expires.to_i.to_s

      fields[5] = cookie.name
      fields[6] = cookie.value
      io.puts(fields.join("\t"))
    end
  end

  private
  # Determine if the cookie's domain and path are valid for
  # the uri.host based on the rules in RFC 2965
  def valid_cookie_for_uri?(uri, cookie)
    cookie_domain = self.class.strip_port(cookie.domain)

    # reject cookies whose domains do not contain an embedded dot
    # cookies for localhost and .local. are exempt from this rule
    return false if cookie_domain !~ /.\../ && cookie_domain !~ /(localhost|\.?local)\.?$/

    # Permitted:     A Set-Cookie from request-host x.foo.com for Domain=.foo.com
    # Not Permitted: A Set-Cookie from request-host y.x.foo.com for Domain=.foo.com because y.x contains a dot
    # Not Permitted: A Set-Cookie from request-host foo.com for Domain=.bar.com
    match = uri.host.match(/#{cookie_domain}/i)
    return false if match.nil? || match.pre_match =~ /.\../

    true
  end

  # Remove expired cookies
  def cleanup
    @jar.each do |domain, paths|
      paths.each do |path, names|
        names.each do |cookie_name, cookie|
          if cookie.expired?
            paths[path].delete(cookie_name)
          end
        end
      end
    end
  end

  def self.strip_port(host)
    host.gsub(/:[0-9]+$/,'')
  end
end

