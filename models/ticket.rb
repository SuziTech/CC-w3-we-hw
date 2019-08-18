require_relative("../db/sql_runner")

class Ticket

  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (film_id, customer_id)
    VALUES ($1, $2) RETURNING id"
    values = [@film_id, @customer_id]
    ticket = SqlRunner.run(sql, values)[0];
    @id = ticket['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (film_id, customer_id) = ($1, $2)
    WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * FROM tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values).first
    return Movie.new(film)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Star.new(customer)
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    data = SqlRunner.run(sql)
    return data.map{|ticket| Ticket.new(ticket)}
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end
