$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'mechanize/cookie'
require 'uri'
require 'test_includes'

module Enumerable
  def combine
    masks = inject([[], 1]){|(ar, m), e| [ar<<m, m<<1]}[0]
    all = masks.inject(0){|al, m| al|m}

    result = []
    for i in 1..all do
      tmp = []
      each_with_index do |e, idx|
        tmp << e unless (masks[idx] & i) == 0
      end
      result << tmp
    end
    result
  end
end

class CookieClassTest < Test::Unit::TestCase
  def test_parse_dates
    url = URI.parse('http://localhost/')

    yesterday = DateTime.now - 1

    dates = [ "14 Apr 89 03:20:12",
              "14 Apr 89 03:20 GMT",
              "Fri, 17 Mar 89 4:01:33",
              "Fri, 17 Mar 89 4:01 GMT",
              "Mon Jan 16 16:12 PDT 1989",
              "Mon Jan 16 16:12 +0130 1989",
              "6 May 1992 16:41-JST (Wednesday)",
              #"22-AUG-1993 10:59:12.82",
              "22-AUG-1993 10:59pm",
              "22-AUG-1993 12:59am",
              "22-AUG-1993 12:59 PM",
              #"Friday, August 04, 1995 3:54 PM",
              "06/21/95 04:24:34 PM",
              "20/06/95 21:07",
              "95-06-08 19:32:48 EDT",
    ]

    dates.each do |date|
      cookie = "PREF=1; expires=#{date}"
      WWW::Cookie.parse(url, cookie) { |cookie|
        assert_equal(true, cookie.expires < yesterday)
      }
    end
  end

  def test_parse_valid_cookie
    url = URI.parse('http://rubyforge.org/')
    cookie_params = {}
    cookie_params['expires']   = 'expires=Sun, 27-Sep-2037 00:00:00 GMT'
    cookie_params['path']      = 'path=/'
    cookie_params['domain']    = 'domain=.rubyforge.org'
    cookie_params['httponly']  = 'HttpOnly'
    cookie_value = '12345%7D=ASDFWEE345%3DASda'

    expires = DateTime.strptime('Sun, 27-Sep-2037 00:00:00 GMT',
              '%a, %d-%b-%Y %T %Z')
    
    cookie_params.keys.combine.each do |c|
      cookie_text = "#{cookie_value}; "
      c.each_with_index do |key, idx|
        if idx == (c.length - 1)
          cookie_text << "#{cookie_params[key]}"
        else
          cookie_text << "#{cookie_params[key]}; "
        end
      end
      cookie = nil
      WWW::Cookie.parse(url, cookie_text) { |p_cookie| cookie = p_cookie }
      assert_not_nil(cookie)
      assert_equal('12345%7D=ASDFWEE345%3DASda', cookie.to_s)
      assert_equal('/', cookie.path)
      assert_equal('rubyforge.org', cookie.domain)

      # if expires was set, make sure we parsed it
      if c.find { |k| k == 'expires' }
        assert_equal(expires, cookie.expires)
      else
        assert_nil(cookie.expires)
      end
    end
  end

  # If no path was given, use the one from the URL
  def test_cookie_using_url_path
    url = URI.parse('http://rubyforge.org/login')
    cookie_params = {}
    cookie_params['expires']   = 'expires=Sun, 27-Sep-2037 00:00:00 GMT'
    cookie_params['path']      = 'path=/'
    cookie_params['domain']    = 'domain=.rubyforge.org'
    cookie_params['httponly']  = 'HttpOnly'
    cookie_value = '12345%7D=ASDFWEE345%3DASda'

    expires = DateTime.strptime('Sun, 27-Sep-2037 00:00:00 GMT',
              '%a, %d-%b-%Y %T %Z')
    
    cookie_params.keys.combine.each do |c|
      next if c.find { |k| k == 'path' }
      cookie_text = "#{cookie_value}; "
      c.each_with_index do |key, idx|
        if idx == (c.length - 1)
          cookie_text << "#{cookie_params[key]}"
        else
          cookie_text << "#{cookie_params[key]}; "
        end
      end
      cookie = nil
      WWW::Cookie.parse(url, cookie_text) { |p_cookie| cookie = p_cookie }
      assert_not_nil(cookie)
      assert_equal('12345%7D=ASDFWEE345%3DASda', cookie.to_s)
      assert_equal('rubyforge.org', cookie.domain)
      assert_equal('/login', cookie.path)

      # if expires was set, make sure we parsed it
      if c.find { |k| k == 'expires' }
        assert_equal(expires, cookie.expires)
      else
        assert_nil(cookie.expires)
      end
    end
  end

  # If no domain was given, we must use the one from the URL
  def test_cookie_with_url_domain
    url = URI.parse('http://login.rubyforge.org/')
    cookie_params = {}
    cookie_params['expires']   = 'expires=Sun, 27-Sep-2037 00:00:00 GMT'
    cookie_params['path']      = 'path=/'
    cookie_params['domain']    = 'domain=.rubyforge.org'
    cookie_params['httponly']  = 'HttpOnly'
    cookie_value = '12345%7D=ASDFWEE345%3DASda'

    expires = DateTime.strptime('Sun, 27-Sep-2037 00:00:00 GMT',
              '%a, %d-%b-%Y %T %Z')
    
    cookie_params.keys.combine.each do |c|
      next if c.find { |k| k == 'domain' }
      cookie_text = "#{cookie_value}; "
      c.each_with_index do |key, idx|
        if idx == (c.length - 1)
          cookie_text << "#{cookie_params[key]}"
        else
          cookie_text << "#{cookie_params[key]}; "
        end
      end
      cookie = nil
      WWW::Cookie.parse(url, cookie_text) { |p_cookie| cookie = p_cookie }
      assert_not_nil(cookie)
      assert_equal('12345%7D=ASDFWEE345%3DASda', cookie.to_s)
      assert_equal('/', cookie.path)

      assert_equal('login.rubyforge.org', cookie.domain)

      # if expires was set, make sure we parsed it
      if c.find { |k| k == 'expires' }
        assert_equal(expires, cookie.expires)
      else
        assert_nil(cookie.expires)
      end
    end
  end

  def test_parse_cookie_no_spaces
    url = URI.parse('http://rubyforge.org/')
    cookie_params = {}
    cookie_params['expires']   = 'expires=Sun, 27-Sep-2037 00:00:00 GMT'
    cookie_params['path']      = 'path=/'
    cookie_params['domain']    = 'domain=.rubyforge.org'
    cookie_params['httponly']  = 'HttpOnly'
    cookie_value = '12345%7D=ASDFWEE345%3DASda'

    expires = DateTime.strptime('Sun, 27-Sep-2037 00:00:00 GMT',
              '%a, %d-%b-%Y %T %Z')
    
    cookie_params.keys.combine.each do |c|
      cookie_text = "#{cookie_value};"
      c.each_with_index do |key, idx|
        if idx == (c.length - 1)
          cookie_text << "#{cookie_params[key]}"
        else
          cookie_text << "#{cookie_params[key]};"
        end
      end
      cookie = nil
      WWW::Cookie.parse(url, cookie_text) { |p_cookie| cookie = p_cookie }
      assert_not_nil(cookie)
      assert_equal('12345%7D=ASDFWEE345%3DASda', cookie.to_s)
      assert_equal('/', cookie.path)
      assert_equal('rubyforge.org', cookie.domain)

      # if expires was set, make sure we parsed it
      if c.find { |k| k == 'expires' }
        assert_equal(expires, cookie.expires)
      else
        assert_nil(cookie.expires)
      end
    end
  end
end

