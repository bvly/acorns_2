require "#{File.dirname(__FILE__)}/../lib/EdmundsAPITest"
require 'json'
require 'yaml'

describe EdmundsAPITest do
  before(:all) do
    # Load API key from config.yml stored in lib directory.
    # Inside the file should look like:
    #
    # key: yourapikeyhere
    #
    @config = YAML.load_file("#{File.dirname(__FILE__)}/../lib/config.yml")
    @apiKey = @config['key']
    @ed = EdmundsAPITest.new(@apiKey)
  end
  describe "#findVehicle" do
    # Getting a list of vehicle makes only lets you specify the year as a parameter.
    context "by requesting list of car makes of the year 2001" do

      before do
        @make = 'Lexus'
        @model = 'ES 300'
        @year = 2001
        @response = @ed.findVehicle(@year)
      end

      it "response code OK: 200" do
        expect(@response.status).to be == 200
      end

      it "response body is json" do
        expect(@response.headers['Content-Type']).to include('application/json')
      end
      
      # Is it bad practice to have multiple 'expect' inside an 'it' block?
      it "find my car make Lexus ES 300 2001" do
        @makesList = JSON.parse(@response.body)["makes"]
        # verify make exists in list
        expect(@makesList.find { |elem| elem['name'] == @make}).not_to be_nil
        @modelList = @makesList.find { |elem| elem['name'] == @make}["models"]
        # verify model exists in list
        expect(@modelList.find { |elem| elem['name'] == @model }).not_to be_nil
        # doublecheck year
        @yearsList = @modelList.find { |elem| elem['name'] == @model}["years"]
        expect(@yearsList.find { |elem| elem['year'] == @year }).not_to be_nil
      end
    end
  end
end
