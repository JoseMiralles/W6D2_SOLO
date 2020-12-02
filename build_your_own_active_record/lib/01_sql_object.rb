require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns != nil
    query = <<-SQL
      SELECT *
      FROM #{self.table_name}
      LIMIT 1
    SQL
    res = DBConnection.execute2(query)
    @columns = res[0].map {|el| el.to_sym}
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) {self.attributes[col]}
      define_method("#{col}=") {|val| self.attributes[col] = val}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # ex: If the class name is Cat then return cats.
    return @table_name if @table_name != nil
    self.to_s.tableize
  end

  def self.all
    query = <<-SQL
      SELECT #{self.table_name}.*
      FROM #{self.table_name};
    SQL
    self.parse_all(DBConnection.execute(query))
  end

  def self.parse_all(results)
    results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    query = <<-SQL
      SELECT #{self.table_name}.*
      FROM #{self.table_name}
      WHERE id = #{id}
    SQL
    hash = DBConnection.execute(query).first
    return nil if hash == nil
    self.new(hash)
  end

  def initialize(params = {})
    params.each do |k, v|
       if self.class.columns.include?(k.to_sym)
        self.send("#{k}=", v)
       else
        raise "unknown attribute '#{k}'"
       end
    end
  end

  def attributes
    @attributes = {} if @attributes == nil
    @attributes
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
