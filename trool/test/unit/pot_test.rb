require 'test_helper'

require 'rubygems'
require 'ruby-debug'
require 'date'
Debugger.start

class PotParserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @content = File.open('git.pot', 'r').read
    parser = PotInputParser.new @content
    parser.parse_copyright
    parser.parse_headers
    @ret = parser.all_dict
  end

  test "get author" do
    assert_equal "Couch Dwellers", @ret[:first_author]
  end

  test "get first author email" do
    assert_equal "couch@toostis.com", @ret[:first_author_email]
  end

  test "get first author year" do
    assert_equal 2011, @ret[:first_author_year]
  end

  test "get project id version" do
    assert_equal "1.7.5", @ret[:project_id_version]
  end

  test "get report msgid bugs to" do
    assert_equal "Git Mailing List <git@vger.kernel.org>",
      @ret[:report_msgid_bugs_to]
  end
  
  test "get pot creation date" do
    assert_equal DateTime.parse("2011-04-25 09:37+0100"),
      @ret[:pot_creation_date]
  end

  test "get last translator" do
    assert_equal "Couch Dwellers <couch@toostis.com>", @ret[:last_translator]
  end

  test "get language team" do
    assert_equal "Lithuanian <couch@toostis.com>", @ret[:language_team]
  end

  test "get mime version" do
    assert_equal "1.0", @ret[:mime_version]
  end

  test "get content type" do
    assert_equal "text/plain; charset=UTF-8", @ret[:content_type]
  end

  test "get content transfer encoding" do
    assert_equal "8bit", @ret[:content_transfer_encoding]
  end

end
