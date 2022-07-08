require 'json'

class WorkItems
  attr_accessor :org, :project, :queries, :tickets 

  def initialize(options)
    @org = options[:org] || 'https://dev.azure.com/office'
    @project = options[:project] || 'OE'
    @queries = options[:query].split || Array.new()
    get_tickets_from_queries
  end

  def create_report_from_tickets(options)
    File.open('report.txt', 'w') do |report|
      report_intro(report, options)

      @tickets.each do |ticket|
       report_list_tickets(report, ticket)
      end

      report_closing(report, options)
    end
  end

  def to_s
    puts "Org: #{@org}"
    puts "Project: #{@project}"
    print "Queries: "
    @queries.each { |query| printf('%s, ', query) }
  end

  private 

  def get_tickets_from_queries
    @tickets = Array.new()

    @queries.each do |query|
      returned_query_json = query_query(query)
      parsed_query_json = parse_query_json(returned_query_json)
      
      parsed_query_json.each { |ticket| @tickets << Ticket.new(ticket) } unless parsed_query_json.nil?
    end
  end

  def query_query(query) # lol
    %x[#{az} boards query --id #{query} --org #{@org}]
  rescue 
    STDERR.puts 'az command failed. Make sure that it is installed' 
    exit 1
  end

  def parse_query_json(returned_query_json)
    JSON.parse(returned_query_json)
  rescue JSON::ParserError
    nil
  end

  def az 
    ::File.join '/', 'usr', 'local', 'bin', 'az'
  end

  def report_list_tickets(report, ticket)
    report.printf("\t - %s", ticket.fields["System.Title"])
    report.printf(" (%s)", ticket.fields["System.State"])
    report.puts
    report.printf("\t\t * %s", url(ticket.id))
    report.puts; report.puts
  end

  def report_intro(report, options)
    report.printf("%s,", options[:greeting] || "Hi")
    report.puts; report.puts
    report.printf("%s", options[:intro] || '')
    report.printf("%s:", options[:intro] ? ". I also worked on the following tickets" : "This week I worked on the following tickets")
    report.puts; report.puts
  end

  def report_closing(report, options)
    report.printf("%s,", options[:closings] || "Cheers")
    report.puts; report.puts
    report.printf("%s", options[:signature] || "Anon")
  end

  def url(ticket_id) 
    ::File.join @org, @project, '_workitems', 'edit', ticket_id.to_s
  end

  class Ticket
    def self.method_missing(key, *args)
      warn "Query provided insufient data"
      nil
    end

    def initialize(ticket_data)
      ticket_data.each do |key, value| 
        instance_variable_set("@#{key}", value)

        define_singleton_method key.to_sym do
          instance_variable_get("@#{key}") 
        end
      end
    end
  end
end