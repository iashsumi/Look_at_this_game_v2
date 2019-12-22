class Credential
  def self.create
    # リージョン
    region = 'ap-northeast-1'
    if Rails.env == 'development'
      # ローカルの場合
      Aws.config.update(
        endpoint: 'http://minio:9000',
        access_key_id: 'minio_access_key',
        secret_access_key: 'minio_secret_key',
        force_path_style: true,
        region: region
      )
    else
      # 本番
      Aws.config.update(
        region: region
      )
    end
    Aws::S3::Client.new
  end
end