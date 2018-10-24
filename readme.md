# SMS Order Notifications

### ⏱ 15 min build time

## Why build SMS order notifications?

Have you ever ordered home delivery to find yourself wondering whether your order was received correctly and how long it'll take to arrive? Some experiences are seamless and others... not so much.

For on-demand industries such as food delivery, ridesharing and logistics, excellent customer service during the ordering process is essential. One easy way to stand out from the crowd is providing proactive communication to keep your customers in the loop about the status of their orders. Regardless of whether your customer is waiting for a package delivery or growing "hangry" (i.e. Hungry + Angry) awaiting their food delivery, sending timely SMS order notifications is a great strategy to create a seamless user experience.

The [MessageBird SMS Messaging API](https://developers.messagebird.com/docs/sms-messaging) provides an easy way to fully automate and integrate a notifications application into your order handling software. Busy employees can trigger the notifications application with the push of a single button - no more confused hangry customers and a best-in-class user experience, just like that!

### Getting Started

In this MessageBird Developer Guide, we'll show you how to build a runnable Order Notifications application in Ruby. The application is a prototype order management system deployed by our fictitious food delivery company, _Birdie NomNom Foods_.

Birdie NomNom Foods have set up the following workflow:

* New incoming orders are in a _pending_ state.
* Once the kitchen starts preparing an order, it moves to the _confirmed_ state. A message is sent to the customer to inform them about this.
* When the food is made and handed over to the delivery driver, staff marks the order _delivered_. A message is sent to the customer to let them know it will arrive momentarily.
* If preparation takes longer than expected, it can be moved to a _delayed_ state. A message is sent to the customer asking them to hang on just a little while longer. Thanks to this, Birdie NomNom Foods saves time spent answering _"Where's my order?_" calls.

To run the application, you will need [Ruby](https://www.ruby-lang.org/en/) and [bundler](https://bundler.io/).

**Pro-tip:** Follow this tutorial to build the whole application from scratch or, if you want to see it in action right away, you can download, clone or fork the sample application from the [MessageBird Developer Guides GitHub repository](https://github.com/messagebirdguides/notifications-guide-ruby).

Let's open a console pointed to the directory into which you've placed the sample application and run the following command to install it:

```
bundle install
```

This command will install the [MessageBird SDK for Ruby](https://rubygems.org/gems/messagebird-rest) and other dependencies, as defined in `Gemfile`, from RubyGems.

## Configuring the MessageBird SDK

Now, let's open `app.rb`, the main file of the sample application. You'll find the following lines:

``` ruby
require 'dotenv'
require 'sinatra'
require 'messagebird'

set :root, File.dirname(__FILE__)
Dotenv.load if Sinatra::Base.development?

client = MessageBird::Client.new(ENV['MESSAGEBIRD_API_KEY'])
```

Next, we'll replace the string _YOUR_API_KEY_ with a _live_ access key from your MessageBird account. You can create or retrieve a key from the [API access (REST) tab](https://dashboard.messagebird.com/en/developers/access) in the _Developers_ section. It's also possible to use a _test_ key to test the application. In this case, you can see the API output on the console, but no live SMS messages will be sent.

**Pro-tip:** Hardcoding your credentials in the code is a risky practice that should never be used in production applications.  A better method, also recommended by the [Twelve-Factor App Definition](https://12factor.net/), is to use environment variables.

We've added [dotenv](https://rubygems.org/gems/dotenv) to the sample application, so you can supply your API key in a file named `.env`. You can copy the provided file `env.example` to `.env` and add your API key like this:

```
MESSAGEBIRD_API_KEY=YOUR-API-KEY
```

## Notifying Customer by Triggering an SMS

The sample application triggers SMS delivery in the `/updateOrder` route together with updating the stored data.

Sending a message with the MessageBird SDK is straightforward - we simply call the `message_create` method with a few arguments:

```ruby
# Send the message through MessageBird's API
client.message_create("NomNom", [order.phone], body)
```

The arguments are as follows:

* `originator`: This is the first parameter. It represents a sender ID for the SMS, either a telephone number (including country code) or an alphanumeric string with at most 11 characters.
* `recipients`: This is the second parameter. It's an array of one or more phone numbers to send the message to.
* `body`: This is the third parameter. It's the content of the message.

Check out [the SMS Messaging API documentation](https://developers.messagebird.com/docs/messaging#messaging-send) for optional arguments for your application.

## Testing the Application

The sample application works on a set of test data defined in a variable called `OrderDatabase` in `app.rb`. To test the full flow, replace one of the phone numbers with your own to receive the message on your phone:

``` ruby
# Set up Order "Database"
order_database = [
  {
    name: 'Hannah Hungry',
    phone: '+319876543210', # <- put your number here for testing
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
```

Now, it's time to run the following command from your console:

```
ruby app.rb
```

Then, point your browser at http://localhost:4567/ to see the list of orders.

Click on one of the buttons in the _Action_ column to trigger a status change and, at the same time, automatically send a message. Tada!

## Nice work!

You now have a running SMS Notifications application!

You can now use the flow, code snippets and UI examples from this tutorial as an inspiration to build your own SMS Notifications system. Don't forget to download the code from the [MessageBird Developer Guides GitHub repository](https://github.com/messagebirdguides/notifications-guide-ruby).

## Next steps

Want to build something similar but not quite sure how to get started? Please feel free to let us know at support@messagebird.com, we'd love to help!
