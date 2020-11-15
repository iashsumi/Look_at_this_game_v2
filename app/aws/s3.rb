# frozen_string_literal: true

class S3
  # バケット名
  BUCKET = "look-at-this-game-2ch"

  def initialize
    # 認証情報取得
    @client = Credential.create
  end

  def put_object(file_name, body, bucket = BUCKET)
    @client.put_object(bucket: bucket, key: file_name, body: body)
  end

  def fetch_object(file_name, bucket = BUCKET)
    @client.get_object(bucket: bucket, key: file_name).body.read
  end
end
