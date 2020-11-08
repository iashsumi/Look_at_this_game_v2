# frozen_string_literal: true

class Dynamo
  TABLE = 'LookAtThisGameOGP'

  def initialize
    @client = Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
  end

  def get_item(id)
    @client.get_item({
      key: {
        id: id
      }, 
      table_name: TABLE
    })
  end

  def update_item(params)
    id = params[:id]
    title = params[:title]
    description = params[:description]
    image_path = params[:image_path]
    @client.update_item({
      expression_attribute_names: {
        "#title" => "title", 
        "#description" => "description", 
        "#image_path" => "image_path"
      },
      expression_attribute_values: {
        ":title" => title, 
        ":description" => description, 
        ":image_path" => image_path 
      },
      key: {
        id: id
      },
      table_name: TABLE, 
      update_expression: "SET #title = :title, #description = :description, #image_path = :image_path"
    })
  end
end
