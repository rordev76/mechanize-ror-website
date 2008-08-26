Gem::Specification.new do |s|
  s.name = %q{mechanize}
  s.version = "0.7.7.20080826145538"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson"]
  s.date = %q{2008-08-26}
  s.description = %q{The Mechanize library is used for automating interaction with websites.  Mechanize automatically stores and sends cookies, follows redirects, can follow links, and submit forms.  Form fields can be populated and submitted.  Mechanize also keeps track of the sites that you have visited as a history.}
  s.email = %q{aaronp@rubyforge.org}
  s.extra_rdoc_files = ["EXAMPLES.txt", "FAQ.txt", "GUIDE.txt", "History.txt", "LICENSE.txt", "Manifest.txt", "NOTES.txt", "README.txt"]
  s.files = ["EXAMPLES.txt", "FAQ.txt", "GUIDE.txt", "History.txt", "LICENSE.txt", "Manifest.txt", "NOTES.txt", "README.txt", "Rakefile", "eg/flickr_upload.rb", "eg/mech-dump.rb", "eg/proxy_req.rb", "eg/rubyforge.rb", "eg/spider.rb", "lib/mechanize.rb", "lib/www/mechanize.rb", "lib/www/mechanize/content_type_error.rb", "lib/www/mechanize/cookie.rb", "lib/www/mechanize/cookie_jar.rb", "lib/www/mechanize/file.rb", "lib/www/mechanize/file_saver.rb", "lib/www/mechanize/form.rb", "lib/www/mechanize/form/button.rb", "lib/www/mechanize/form/check_box.rb", "lib/www/mechanize/form/field.rb", "lib/www/mechanize/form/file_upload.rb", "lib/www/mechanize/form/image_button.rb", "lib/www/mechanize/form/multi_select_list.rb", "lib/www/mechanize/form/option.rb", "lib/www/mechanize/form/radio_button.rb", "lib/www/mechanize/form/select_list.rb", "lib/www/mechanize/headers.rb", "lib/www/mechanize/history.rb", "lib/www/mechanize/inspect.rb", "lib/www/mechanize/list.rb", "lib/www/mechanize/monkey_patch.rb", "lib/www/mechanize/page.rb", "lib/www/mechanize/page/base.rb", "lib/www/mechanize/page/frame.rb", "lib/www/mechanize/page/link.rb", "lib/www/mechanize/page/meta.rb", "lib/www/mechanize/pluggable_parsers.rb", "lib/www/mechanize/redirect_limit_reached_error.rb", "lib/www/mechanize/response_code_error.rb", "lib/www/mechanize/unsupported_scheme_error.rb", "mechanize.gemspec", "test/data/htpasswd", "test/data/server.crt", "test/data/server.csr", "test/data/server.key", "test/data/server.pem", "test/helper.rb", "test/htdocs/alt_text.html", "test/htdocs/bad_form_test.html", "test/htdocs/button.jpg", "test/htdocs/empty_form.html", "test/htdocs/file_upload.html", "test/htdocs/find_link.html", "test/htdocs/form_multi_select.html", "test/htdocs/form_multival.html", "test/htdocs/form_no_action.html", "test/htdocs/form_no_input_name.html", "test/htdocs/form_select.html", "test/htdocs/form_select_all.html", "test/htdocs/form_select_none.html", "test/htdocs/form_select_noopts.html", "test/htdocs/form_set_fields.html", "test/htdocs/form_test.html", "test/htdocs/frame_test.html", "test/htdocs/google.html", "test/htdocs/iframe_test.html", "test/htdocs/index.html", "test/htdocs/link with space.html", "test/htdocs/meta_cookie.html", "test/htdocs/no_title_test.html", "test/htdocs/relative/tc_relative_links.html", "test/htdocs/tc_bad_links.html", "test/htdocs/tc_base_link.html", "test/htdocs/tc_blank_form.html", "test/htdocs/tc_checkboxes.html", "test/htdocs/tc_encoded_links.html", "test/htdocs/tc_follow_meta.html", "test/htdocs/tc_form_action.html", "test/htdocs/tc_links.html", "test/htdocs/tc_no_attributes.html", "test/htdocs/tc_pretty_print.html", "test/htdocs/tc_radiobuttons.html", "test/htdocs/tc_referer.html", "test/htdocs/tc_relative_links.html", "test/htdocs/tc_textarea.html", "test/htdocs/unusual______.html", "test/servlets.rb", "test/ssl_server.rb", "test/test_authenticate.rb", "test/test_bad_links.rb", "test/test_blank_form.rb", "test/test_checkboxes.rb", "test/test_content_type.rb", "test/test_cookie_class.rb", "test/test_cookie_jar.rb", "test/test_cookies.rb", "test/test_encoded_links.rb", "test/test_errors.rb", "test/test_follow_meta.rb", "test/test_form_action.rb", "test/test_form_as_hash.rb", "test/test_form_button.rb", "test/test_form_no_inputname.rb", "test/test_forms.rb", "test/test_frames.rb", "test/test_get_headers.rb", "test/test_gzipping.rb", "test/test_hash_api.rb", "test/test_history.rb", "test/test_history_added.rb", "test/test_html_unscape_forms.rb", "test/test_if_modified_since.rb", "test/test_keep_alive.rb", "test/test_links.rb", "test/test_mech.rb", "test/test_mechanize_file.rb", "test/test_multi_select.rb", "test/test_no_attributes.rb", "test/test_option.rb", "test/test_page.rb", "test/test_pluggable_parser.rb", "test/test_post_form.rb", "test/test_pretty_print.rb", "test/test_radiobutton.rb", "test/test_redirect_limit_reached.rb", "test/test_referer.rb", "test/test_relative_links.rb", "test/test_response_code.rb", "test/test_save_file.rb", "test/test_select.rb", "test/test_select_all.rb", "test/test_select_none.rb", "test/test_select_noopts.rb", "test/test_set_fields.rb", "test/test_ssl_server.rb", "test/test_subclass.rb", "test/test_textarea.rb", "test/test_upload.rb"]
  s.has_rdoc = true
  s.homepage = %q{  http://mechanize.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mechanize}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Mechanize provides automated web-browsing}
  s.test_files = ["test/test_authenticate.rb", "test/test_bad_links.rb", "test/test_blank_form.rb", "test/test_checkboxes.rb", "test/test_content_type.rb", "test/test_cookie_class.rb", "test/test_cookie_jar.rb", "test/test_cookies.rb", "test/test_encoded_links.rb", "test/test_errors.rb", "test/test_follow_meta.rb", "test/test_form_action.rb", "test/test_form_as_hash.rb", "test/test_form_button.rb", "test/test_form_no_inputname.rb", "test/test_forms.rb", "test/test_frames.rb", "test/test_get_headers.rb", "test/test_gzipping.rb", "test/test_hash_api.rb", "test/test_history.rb", "test/test_history_added.rb", "test/test_html_unscape_forms.rb", "test/test_if_modified_since.rb", "test/test_keep_alive.rb", "test/test_links.rb", "test/test_mech.rb", "test/test_mechanize_file.rb", "test/test_multi_select.rb", "test/test_no_attributes.rb", "test/test_option.rb", "test/test_page.rb", "test/test_pluggable_parser.rb", "test/test_post_form.rb", "test/test_pretty_print.rb", "test/test_radiobutton.rb", "test/test_redirect_limit_reached.rb", "test/test_referer.rb", "test/test_relative_links.rb", "test/test_response_code.rb", "test/test_save_file.rb", "test/test_select.rb", "test/test_select_all.rb", "test/test_select_none.rb", "test/test_select_noopts.rb", "test/test_set_fields.rb", "test/test_ssl_server.rb", "test/test_subclass.rb", "test/test_textarea.rb", "test/test_upload.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.5.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.5.0"])
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.5.0"])
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
