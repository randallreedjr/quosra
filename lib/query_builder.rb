class QueryBuilder
  attr_reader :query, :search_term, :categories, :max_results

  def initialize(search_term: '', categories: [], max_results: 10)
    @search_term = search_term
    @categories = categories
    @max_results = max_results
    @query = {}
  end

  def build
    # base bool query
    @query[:query] = {
      :bool => {
        :must => {}
      }
    }
    @query[:size] = max_results

    if search_term.present?
      @query[:query][:bool][:must] = search_term_query
    else
      @query[:query][:bool][:must] =  match_all_query
    end

    if categories.present?
      @query[:query][:bool][:should] = category_filter
      @query[:query][:bool][:minimum_number_should_match] = 1
    end

    return @query
  end

  private

  def match_all_query
    # must
    {
      :match_all => {}
    }
  end

  def search_term_query
    # must
    {
        multi_match: {
            query: search_term,
            fields: ["title^2","description","answers.content^2","categories.title"]
        }
    }
  end

  def category_filter
    # should
    categories.collect do |category|
      { match: { "categories.title" => category} }
    end
  end
end

# Query Target
# GET _search
# {
#     "query": {
#         "bool": {
#             "must": {
#                 "multi_match": {
#                     "query": "Curtis",
#                     "fields": [
#                       "title^2",
#                       "description",
#                       "answers.content^2",
#                       "categories.title"
#                     ]
#                 }
#             },
#             "should": [
#                 { "match": { "categories.title": "Taxes" }},
#                 { "match": { "categories.title": "Retirement" }}
#             ],
#             "minimum_number_should_match": 1
#         }
#     }
# }
