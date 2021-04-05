class AccountAggregate
  attr_reader :user, :amount

  def initialize(user:, amount:)
    @user = user
    @amount = amount
  end

  def copy(**args)
    new_args = {user: user, amount: amount}.merge(args)
    self.class.new(new_args)
  end
end

class BaseEvent
  def apply
    raise 'not implemented'
  end
end

class AddToAccount < BaseEvent
  attr_reader :amount
  def initialize(amount)
    @amount = amount
  end

  def apply(aggregate)
    aggregate.copy(amount: aggregate.amount + amount)
  end
end

class SubtractFromAccount < BaseEvent
  attr_reader :amount
  def initialize(amount)
    @amount = amount
  end

  def apply(aggregate)
    aggregate.copy(amount: aggregate.amount - amount)
  end
end

class CreateAccount < BaseEvent
  attr_reader :user
  STARTING_AMOUNT = 0
  def initialize(user)
    @user = user
  end

  def apply(_aggregate = nil)
    AccountAggregate.new(user: user, amount: STARTING_AMOUNT)
  end
end

# require('./simple_es.rb')
# # => true
# e1 = CreateAccount.new('erik')
# # => #<CreateAccount:0x00007f8bb11675d0 @user="erik">
# e2 = AddToAccount.new(50)
# # => #<AddToAccount:0x00007f8bb117cd90 @amount=50>
# e3 = SubtractFromAccount.new(42)
# # => #<SubtractFromAccount:0x00007f8b8781e1a0 @amount=42>
# [e1, e2, e3].inject(nil) { |aggregate, event| event.apply(aggregate) }
# # => #<AccountAggregate:0x00007f8bb11a75b8 @amount=8, @user="erik">