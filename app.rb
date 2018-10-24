require 'dotenv'
require 'sinatra'
require 'messagebird'
require 'active_support'
require 'active_support/core_ext'

set :root, File.dirname(__FILE__)

#  Load configuration from .env file
Dotenv.load if Sinatra::Base.development?

# Load and initialize MesageBird SDK
client = MessageBird::Client.new(ENV['MESSAGEBIRD_API_KEY'])

order_database = [
  {
    name: 'Hannah Hungry',
    phone: '+319876543211', # <- put your number here for testing
    items: '1 x Hipster Burger + Fries',
    status: 'pending'
  },
  {
    name: 'Mike Madeater',
    phone: '+319876543211', # <- put your number here for testing
    items: '1 x Chef Special Mozzarella Pizza',
    status: 'pending'
  }
]

# Display booking homepage
get '/' do
  erb :orders, locals: { orders: order_database }
end

post '/updateOrder' do
  # read request
  id = params[:id].to_i

  # Get order
  if (order = order_database[id])
    # Update order
    order[:status] = params[:status]

    # Compose a message, based on current status
    case order[:status]
    when 'confirmed'
      body = "#{order[:name]}, thanks for ordering at OmNomNom Foods! We are now preparing your food with love and fresh ingredients and will keep you updated."
    when 'delayed'
      body ="#{order[:name]}, sometimes good things take time! Unfortunately your order is slightly delayed but will be delivered as soon as possible."
    when 'delivered'
      body = "#{order[:name]}, you can start setting the table! Our driver is on their way with your order! Bon appetit!"
    end

    begin
      client.message_create('NomNom', [order[:phone]], body)
      erb :orders, locals: { orders: order_database }
    rescue MessageBird::ErrorException => ex
      errors = ex.errors.each_with_object([]) do |error, memo|
        memo << "Error code #{error.code}: #{error.description}"
      end.join("\n")
      halt 500, errors
    end
  else
    halt 500, 'Invalid input!'
  end
end
