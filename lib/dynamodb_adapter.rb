class DynamodbAdapter
  def initialize(table_name:, dynamodb: Aws::DynamoDB::Client.new)
    @dynamodb = dynamodb
    @table_name = table_name
  end

  def put_item(attributes = {})
    @dynamodb.put_item({
      table_name: @table_name,
      item: attributes
    })
  end

  def delete_item(attributes = {})
    @dynamodb.delete_item({
      table_name: @table_name,
      key: attributes,
    })
  end

  def query(parameters = {})
    @dynamodb.query(parameters)
  end
end
