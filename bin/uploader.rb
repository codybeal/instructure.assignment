require 'sqlite3'
require 'CSV'

class Uploader

  def write_to_table(file_name)
    sql = ''

    CSV.foreach(file_name) do |row|
      # add column headers
      if row.include? 'user_id'
        sql = set_insert_statement 'students', row
      elsif
        row.include? 'course_id'
        sql = set_insert_statement 'courses', row
      else
        statement = "#{sql} VALUES(#{row_to_csv_string row});"
        query_database statement
      end
    end

    delete_file file_name

  end

  def get_courses
    query_database 'SELECT course_name FROM courses WHERE state="active";'
  end

  def get_students(course)
    query_database "SELECT * FROM students WHERE course_id=#{course} AND state='active';"
  end

  private

  def delete_file(file_name)
    File.delete file_name
  end

  def row_to_csv_string(row)
    row.collect { |x| "'#{x}'"} * ','
  end

  def set_insert_statement(table, row)
    "INSERT INTO #{table} (#{row_to_csv_string row})"
  end

  # @param [String] query
  # @return [Array]
  def query_database(query)
    begin
      open_database
      result = @db.execute query
    rescue SQLite3::Exception => e
      raise "Database querying database: #{e.message}"
    ensure
      close_database
    end
    result
  end

  def open_database
    begin
      @db ||= SQLite3::Database.open 'db/students_courses.db'
    rescue SQLite3::Exception => e
      @db.close if @db
      raise "Error opening database: #{e.message}"
    end
  end

  def close_database
    begin
      @db.close if @db
    rescue SQLite3::Exception => e
      raise "Error closing database: #{e.message}"
    ensure
      @db = nil
    end
  end
end