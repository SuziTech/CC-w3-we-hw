require_relative("../db/sql_runner")

require('pry')

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save()
    sql = "INSERT INTO films (title, price)
    VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2)
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end



  # display all the customers for a particular film

  def customers_for_film()
    sql = "SELECT name FROM customers
    INNER JOIN tickets ON customers.id = tickets.customer_id
    WHERE film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_items(customer_data)
  end

  def all_film_tickets()
    sql = "SELECT * FROM tickets WHERE film_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    return ticket_data.map{|ticket| Ticket.new(ticket)}
  end

  # def remaining_budget()
  #   tickets = self.tickets()
  #   casting_fees = tickets.map{|ticket| ticket.fee}
  #   combined_fees = casting_fees.sum
  #   return @price - combined_fees
  # end

  def get_film_id_with_film_title()
    begin
      sql = "SELECT id FROM films WHERE title LIKE '%$1%'"
      values = [@title]
      binding.pry
      nil
      film_id = SqlRunner.run(sql, values)
      p film_id[0]['id']
      return film_id[0]['id'].to_i
    rescue
      return 'No film of that title...'
    end
  end

  def Film.get_price_for_film()
    begin
      sql = "SELECT price FROM films WHERE id = $1"
      values = [@id]
      film_data = SqlRunner.run(sql, values)
      return film_data.map{|film| Film.new(price)}
    rescue
      return 'No price yet for that film...'
    end



  end

  def self.all()
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    return Film.map_items(film_data)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map{|film| Film.new(film)}
    return result
  end

end
