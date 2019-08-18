require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * from customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # display all the films a particular customer has bought tickets for

  def films_for_customer()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON films.id = tickets.film_id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return Film.map_items(film_data)
  end

  def all_customer_tickets()
    sql = "SELECT * FROM tickets where customer_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    return ticket_data.map{|ticket| Ticket.new(ticket)}
  end

  def reduce_customer_funds(amount)
    sql = "UPDATE customers SET funds = funds - amount
    WHERE customer_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    
    return customer_data.map{|customer| Customer.new(customer)}
  end

  def buy_tickets_for_film(number_of_tickets, film_title)
    film_id = Film.get_film_id_with_film_title(film_title)
    if film_id != -1
       amount_customer_owes = Film.get_price_for_film(film_id) * number_of_tickets

    else
      return 'Sorry, we are not showing that film at the moment.'
    end
  end

  # def remaining_funds()
  #   films = self.films()
  #   film_prices = films.map{ |film| film.price.to_i}
  #   combined_prices = film_prices.sum
  #   @funds -= combined_prices
  #   update
  # end

  def self.all()
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return Customer.map_items(customer_data)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map{|customer| Customer.new(customer)}
    return result
  end

end
