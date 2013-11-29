class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2
  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def statement
    -----
  end
end








====================================================================================================================
class Customer
  def statement
    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for {@name}\n"
    @rentals.each do |element|
      this_amount = 0

      #determine amounts for each line
      case element.movie.price_code
      when Movie::REGULAR
        this_amount += 2
        this_amount += (element.days_rented - 2) * 1.5 if element.days_rented > 2
      when Movie::NEW_RELEASE
        this_amount += element.days_rented * 3
      when Movie::CHILDRENS
        this_amount += 1.5
        this_amount += (element.days_rented - 3) * 1.5 if element.days_rented > 3
      end

      #add frequent renter points
      frequent_renter_points += 1
      
      #add bonus for a two day new release rental
      if element.movie.price_code == Movie.NEW_RELEASE &&
        element.days_rented > 1
        frequent_renter_points += 1
      end

      #show figures for this rental
      result += "\t" + each.movie.title + "\t" + this_amount.to_s + "\n"
      total_amount += this_amount
    end
    #add footer lines
    result += "Amount owed is {total_amount}\n"
    result += "You earned {frequent_renter_points} frequent renter points"
    result
  end
end









====================================================================================================================
#Extract rental calculation method

#Good code should communicate what it is doing clearly, and variable names are a key to clear code


def statement 
  ------
  ------
  this_amount = amount_for(elements)
  ------
  ------
end

def amount_for(rental)
  result = 0
  case rental.movie.price_code
  when Movie::REGULAR
    result += 2
    result += (element.days_rented - 2) * 1.5 if element.days_rented > 2
  when Movie::NEW_RELEASE
    result += element.days_rented * 3
  when Movie::CHILDRENS
    result += 1.5
    result += (element.days_rented - 3) * 1.5 if element.days_rented > 3
  end
  result
end











====================================================================================================================
#In most cases a method should be on the object whose data it uses;
  class Rental
    def charge
      result = 0
      case movie.price_code
      when Movie::REGULAR
        result += 2
        result += (days_rented - 2) * 1.5 if days_rented > 2
      when Movie::NEW_RELEASE
        result += days_rented * 3
      when Movie::CHILDRENS
        result += 1.5
        result += (days_rented - 3) * 1.5 if days_rented > 3
      end
      result
    end
  end

class Customer
  ------
  -----
  @rentals.each do |element|
    this_amount = element.charge
  end
  ------
  -----
end












#Extracting Frequent Renter Points
====================================================================================================================

  class Rental
    ------
    -----

    def frequent_renter_points
      (movie.price_code == Movie.NEW_RELEASE && days_rented > 1) ? 2 : 1
    end
  end


#Extract total charge calculated method
====================================================================================================================
  class Customer
    def total_charge
      @rentals.inject(0) { |sum, rental| sum + rental.charge }
    end
  end





















#By reusing calculation logic print result into html page
====================================================================================================================

  class Customer
    def html_statement
      result = "<h1>Rentals for <em>#{@name}</em></h1><p>\n"
      @rentals.each do |element|
        # show figures for this rental
        result += "\t" + each.movie.title + ": " + element.charge.to_s + "<br>\n"
      end
      add footer lines
      result += "<p>You owe <em>{total_charge}</em><p>\n"
      result += "On this rental you earned " +
        "<em>{total_frequent_renter_points}</em> " +
        "frequent renter points<p>"
      result
    end
  end






















====================================================================================================================
#For this to work I had to pass in the length of the rental, which of course is
#data from the rental. The method effectively uses two pieces of data, the length
#of the rental and the type of the movie. Why do I prefer to pass the length of
#rental to the movie rather than the movie type to the rental? It’s because the proposed
#changes are all about adding new types. Type information generally tends
#to be more volatile. If I change the movie type, I want the least ripple effect, so I
#prefer to calculate the charge within the movie.


  class Movie
    def charge(days_rented)
      result = 0
      case price_code
      when REGULAR
        result += 2
        result += (days_rented - 2) * 1.5 if days_rented > 2
      when NEW_RELEASE
        result += days_rented * 3
      when CHILDRENS
        result += 1.5
        result += (days_rented - 3) * 1.5 if days_rented > 3
      end
      result
    end
  end

class Rental
  def charge
    movie.charge(days_rented)
  end
end











====================================================================================================================
#Generate loose coupling between objects
#Design systems whereby the parts that change often are isolated from the parts that stay consistent. That way, if changes are to occur, you will not have to go through all the systems code.

  class Movie
    def charge(days_rented)
      @price.charge(days_rented)
    end

    def price_code=(value)
      @price_code = value
      @price = case price_code
               when REGULAR: RegularPrice.new
               when NEW_RELEASE: NewReleasePrice.new
               when CHILDRENS: ChildrensPrice.new
               end
    end
  end

class RegularPrice
  def charge(days_rented)
    result = 2
    result += (days_rented - 2) * 1.5 if days_rented > 2
    result
  end
end

class NewReleasePrice
  def charge(days_rented)
    days_rented * 3
  end
end

class ChildrensPrice
  def charge(days_rented)
    result = 1.5
    result += (days_rented - 3) * 1.5 if days_rented > 3
    result
  end
end
