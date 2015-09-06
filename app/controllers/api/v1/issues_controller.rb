class Api::V1::IssuesController < ApplicationController
  ## Returns a list of issues
  #
  # GET /api/v1/issues
  #
  # = Example
  #
  #   resp = conn.get("/api/v1/issues")
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "data":[
  #           {
  #             "id":"1",
  #             "type":"issues",
  #             "attributes":{
  #               "title":"Test issue",
  #               "description":"Just testing",
  #               "priority":"minor",
  #               "status":"open",
  #               "created_at":"2015-09-06T15:53:51.594Z",
  #               "updated_at":"2015-09-06T15:53:51.594Z"
  #             }
  #           },
  #           {
  #             "id":"2",
  #             "type":"issues",
  #             "attributes":{
  #               "title":"Test issue 2",
  #               "description":"Just testing",
  #               "priority":"major",
  #               "status":"open",
  #               "created_at":"2015-09-06T16:02:25.640Z",
  #               "updated_at":"2015-09-06T16:02:25.640Z"
  #             }
  #           }
  #         ],
  #         "meta":{
  #           "total":2
  #         }
  #       }
  def index
    @issues = Issue.all

    render json: @issues, meta: { total: @issues.count }
  end
end
