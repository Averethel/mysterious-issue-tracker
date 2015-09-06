class Api::V1::IssuesController < ApplicationController
  before_action :set_issue, only: [:show]
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

  ## Returns single issue
  #
  # GET /api/v1/issues/:id
  #
  # = Example
  #
  #   resp = conn.get("/api/v1/issues/1")
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "data":{
  #           "id":"1",
  #           "type":"issues",
  #           "attributes":{
  #             "title":"Test issue",
  #             "description":"Just testing",
  #             "priority":"minor",
  #             "status":"open",
  #             "created_at":"2015-09-06T15:53:51.594Z",
  #             "updated_at":"2015-09-06T15:53:51.594Z"
  #           }
  #         }
  #       }
  def show
    render json: @issue
  end

  ## Creates an issue
  #
  # POST /api/v1/issues
  #
  # body parameters:
  #   issue[tite]: STRING, required
  #   issue[description]: STRING, required
  #   issue[priority]: STRING, required, [minor, major, critical, blocker]
  #
  # = Examples
  #
  #   resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'critical'}})
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "data":{
  #           "id":"2",
  #           "type":"issues",
  #           "attributes":{
  #             "title":"No comments",
  #             "description":"Can't comment issues",
  #             "priority":"critical",
  #             "status":"open",
  #             "created_at":"2015-09-06T15:53:51.594Z",
  #             "updated_at":"2015-09-06T15:53:51.594Z"
  #           }
  #         }
  #       }
  #
  #   resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments'})
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   => {
  #        "errors":[
  #          {
  #            "status":"422",
  #            "title":"Invalid description",
  #            "detail":"can't be blank"
  #          },
  #          {
  #            "status":"422",
  #            "title":"Invalid priority",
  #            "detail":"can't be blank"
  #          }
  #        ]
  #      }
  def create
    @issue = Issue.new(issue_params)
    if @issue.save
      render json: @issue, status: :created, location: api_v1_issue_url(@issue)
    else
      render json: {
        errors: @issue.errors.map do |field, message|
          {
            status: '422',
            title: "Invalid #{field}",
            detail: message
          }
        end
      }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    invalid_params(e)
  end
private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :priority)
  end

  def invalid_params(error)
    render json: {
      errors: [{
        status: '422',
        title: "Invalid JSON submitted",
        detail: error.message
    }]}, status: :unprocessable_entity
  end
end
