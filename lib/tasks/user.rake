namespace :user do
  desc "Create user"
  task create_user: :environment do
    dynamodb = Aws::DynamoDB::Client.new
    table_name = "users"
    begin
      dynamodb.describe_table(table_name: table_name)
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException
      dynamodb.create_table(
        table_name: table_name,
        attribute_definitions: [
          {
            attribute_name: "user_id",
            attribute_type: "N",
          },
          {
            attribute_name: "name",
            attribute_type: "S",
          },
          {
            attribute_name: "gender",
            attribute_type: "S",
          },
        ],
        key_schema: [
          {
            attribute_name: "user_id",
            key_type: "HASH"
          },
          {
            attribute_name: "name",
            key_type: "RANGE",
          },
        ],
        global_secondary_indexes: [
          index_name: "range_ids",
          key_schema: [
            {
              attribute_name: "gender",
              key_type: "HASH",
            },
            {
              attribute_name: "user_id",
              key_type: "RANGE",
            },
          ],
          projection: {
            projection_type: "ALL",
          },
          provisioned_throughput: {
            read_capacity_units: 25,
            write_capacity_units: 25,
          },
        ],
        provisioned_throughput: {
          read_capacity_units: 25,
          write_capacity_units: 25,
        },
      )
      puts "Created successfully!"
    end
  end
end
