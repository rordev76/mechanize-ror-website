require File.dirname(__FILE__) + "/helper"

class TestEncodedLinks < Test::Unit::TestCase
  include TestMethods

  def setup
    @agent = WWW::Mechanize.new
    @page = @agent.get("http://localhost/tc_encoded_links.html")
  end

  def test_click_link
    link = @page.links.first
    assert_equal('/form_post?a=b&amp;b=c', link.href)
    page = @agent.click(link)
    assert_equal("http://localhost/form_post?a=b&b=c", page.uri.to_s)
  end

  def test_hpricot_link
    page = @agent.click(@page.search('a').first)
    assert_equal("http://localhost/form_post?a=b&b=c", page.uri.to_s)
  end
end
