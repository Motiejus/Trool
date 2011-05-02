require 'date'

class Pot < ActiveRecord::Base
  has_many :pos
end

# Returns hash from which Pot can be populated
class PotInputParser
  attr_reader :all_dict;

  def initialize(content)
    @pot = content
    @all_dict = {}
  end

  def parse_copyright
    # Fourth line of the content
    raise "bad @pot" unless @pot
    line = @pot.split("\n")[3]
    all, first_author, first_author_email, first_author_year =\
        line.match(/# (.*) <(.*)>, (\d+)/).to_a
    if not (first_author and first_author_email and first_author_year):
      raise "Wrong Line: %s expected author, email, year." % line
    end

    @all_dict[:first_author] = first_author
    @all_dict[:first_author_email] = first_author_email
    @all_dict[:first_author_year] = Integer(first_author_year)
  end

  def parse_headers
    fetchable = {
        :project_id_version => "Project-Id-Version: (.*)\\\\n",
        :report_msgid_bugs_to => "Report-Msgid-Bugs-To: (.*)\\\\n",
        :pot_creation_date => "POT-Creation-Date: (.*)\\\\n",
    }
    fetchable.each { |k,re| 
        val = @pot.match(re)[1]
        raise "Wrong %s: %s" % [k.replace(/: .*/, ''), val] unless val
        @all_dict[k] = val
    }
    @all_dict[:pot_creation_date] = DateTime.parse(
        @all_dict[:pot_creation_date])
  end

  def parse_messages
  end
end
