require "uri"
require "net/http"
require 'json/ext'

url = URI("https://api.github.com/repos/subham2595/dummy/releases")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Authorization"]    = "token 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"
request["Content-Type"]     = "application/json"

file = File.open "release.json"
data = JSON.load file

body = {
    "tag_name"          => data["release_name"],
    "target_commitish"  => data["repo_name"],
    "name"              => data["release_description"],
    "body"              => data["commit_sha"],
    "owner"             => data["repo_owner"],
    "draft"             => false,
    "prerelease"        => false
}

request.body = body.to_json
response = https.request(request)

########################################
print "This is showing actual error/success \n"
print response.read_body + "\n\n\n"
########################################

print "This is showing custom error/success message \n"
if response.code.to_i == 201
    print "Released successfully \n\n\n"
elsif response.code.to_i == 401
    print "Invalid credentials, please check your credentials \n\n\n"
elsif response.code.to_i == 404
    print "Not found \n\n\n"
elsif response.code.to_i == 422
    print "Validation error occured, please check \n\n\n"
else
    print "Some error occured, please check your data \n\n\n"
end
