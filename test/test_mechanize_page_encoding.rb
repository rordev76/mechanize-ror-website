# -*- coding: utf-8 -*-
require 'helper'
require 'cgi'

# tests for Page encoding and charset and parsing

class TestMechanizePageEncoding < Test::Unit::TestCase

  def setup
    @agent = Mechanize.new
    @uri = URI('http://localhost/')
    @response_headers = { 'content-type' => 'text/html' }
    @body = '<title>hi</title>'
  end

  def util_page body = @body, headers = @response_headers
    body.force_encoding Encoding::BINARY if body.respond_to? :force_encoding
    Mechanize::Page.new @uri, headers, body, 200, @agent
  end

  def test_page_charset
    charset = Mechanize::Page.charset 'text/html;charset=vAlue'
    assert_equal 'vAlue', charset
  end

  def test_page_charset_upcase
    charset = Mechanize::Page.charset 'TEXT/HTML;CHARSET=UTF-8'
    assert_equal 'UTF-8', charset
  end

  def test_page_semicolon
    charset = Mechanize::Page.charset 'text/html;charset=UTF-8;'
    assert_equal 'UTF-8', charset
  end

  def test_page_charset_no_chaset_token
    charset = Mechanize::Page.charset 'text/html'
    assert_nil charset
  end

  def test_page_charset_returns_nil_when_charset_says_none
    charset = Mechanize::Page.charset 'text/html;charset=none'

    assert_nil charset
  end

  def test_page_charset_multiple
    charset = Mechanize::Page.charset 'text/html;charset=111;charset=222'

    assert_equal '111', charset
  end

end
