# Rebuild elasticsearch index before each elasticsearch spec
RSpec.configure do |config|
  config.before(:each, elasticsearch: true) do
    if Question.__elasticsearch__.index_exists?(index: Question.index_name)
      Question.__elasticsearch__.delete_index!(index: Question.index_name)
    end
    Question.__elasticsearch__.create_index!(index: Question.index_name)
    Question.import(index: Question.index_name)
  end
end
