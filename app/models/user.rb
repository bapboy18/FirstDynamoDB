class User
  attr_reader :user_id, :name
  attr_accessor :gender, :age
  ATTRIBUTES = %i(user_id name gender age)

  def initialize(user_id:, name:, gender:, age:)
    @user_id = user_id
    @name = name
    @gender = gender
    @age = age
  end

  def save
    self.class.dynamodb_adapter.put_item(attributes)
  end

  def destroy!(attributes)
    self.class.dynamodb_adapter.delete_item(attributes)
  end

  def attributes
    self.class::ATTRIBUTES.map do |attribute|
      [attribute, __send__(attribute)]
    end.to_h
  end

  class << self
    def dynamodb_adapter
      @dynamodb_adapter ||= DynamodbAdapter.new(table_name: "users")
    end

    def query_by_ids(min_id:, max_id:, gender:)
      parameters = { table_name: "users",
        index_name: "range_ids",
        key_condition_expression:
          "gender = :gender AND user_id BETWEEN :min_id AND :max_id",
        expression_attribute_values: {
          ":gender": gender,
          ":min_id": min_id,
          ":max_id": max_id,
        },
      }
      users = dynamodb_adapter.query(parameters)
      users.items.map! {|item| User.new(item.symbolize_keys)}
    end
  end
end
