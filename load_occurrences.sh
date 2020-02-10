set -e

PROJECT_ACCESS_TOKEN="<token here>"

#curl --request GET \
      #--url "https://api.rollbar.com/api/1/item_by_counter/229?access_token=${PROJECT_ACCESS_TOKEN}"

# 142 -> 825778720
# 229 -> 857758927

curl --request GET \
      --url "https://api.rollbar.com/api/1/item/857758927/instances?access_token=${PROJECT_ACCESS_TOKEN}" > 229_occurrences.json
