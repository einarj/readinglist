class Book #< ActiveRecord::Base

  attr_accessor :id, :title, :author

  def all
    $redis.get("readinglist:books")
  end

  #TODO: Write tests for this

  def create

    sid = nil

    $redis.multi do
      # Get an id for the book
      sid = $redis.incr("readinglist:books:counter")
      # Save the book
      $redis.sadd "readinglist:books:#{sid}", self.to_json
      # Add to author index
      $redis.sadd "readinglist:authors:#{author}", sid
      # Add to title index
      $redis.sadd "readinglist:titles:#{title}", sid
    end

    sid
  end

  def self.find_by_id(id)
    json_book = $redis.smembers("readinglist:books:#{id}")
    #json_parsed = JSON.parse(json_book)
    #book = Book.new
    #book.title = json_parsed["title"]
    #book.author = json_parsed["author"]
    #book.id = id

    #book
  end


end
