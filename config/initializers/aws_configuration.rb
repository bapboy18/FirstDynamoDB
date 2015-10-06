aws_config = YAML.load(ERB.new(File.read("config/database.yml")).result)
Aws.config.update(aws_config[Rails.env])
