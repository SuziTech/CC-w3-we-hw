require_relative('models/ticket')
require_relative('models/film')
require_relative('models/customer')

require('pry')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

  film1 = Film.new({
    'title' => 'The Third Man',
    'price' => 8.99
  })

  film1.save()

  film2 = Film.new({
    'title' => 'Grease',
    'price' => 5.99
  })

  film2.save()

  film3 = Film.new({
    'title' => 'When Harry Met Sally',
    'price' => 7.99
  })

  film3.save()

  customer1 = Customer.new({
    'name' => 'Joe',
    'funds' => 49.99
  })

  customer1.save()


  customer2 = Customer.new({
    'name' => 'Mary',
    'funds' => 23.50
  })

  customer2.save()

  customer3 = Customer.new({
    'name' => 'Julia',
    'funds' => 37.00
  })

  customer3.save()

  ticket1 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id})
  ticket2 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer2.id})
  ticket3 = Ticket.new({'film_id' => film2.id, 'customer_id' => customer1.id})
  ticket4 = Ticket.new({'film_id' => film2.id, 'customer_id' => customer2.id})
  ticket5 = Ticket.new({'film_id' => film2.id, 'customer_id' => customer3.id})
  ticket6 = Ticket.new({'film_id' => film3.id, 'customer_id' => customer1.id})
  ticket7 = Ticket.new({'film_id' => film3.id, 'customer_id' => customer2.id})

  ticket1.save()
  ticket2.save()
  ticket3.save()
  ticket4.save()
  ticket5.save()
  ticket6.save()
  ticket7.save()

  binding.pry
  nil
