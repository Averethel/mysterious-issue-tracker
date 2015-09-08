class Api::V1::IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :update, :destroy, :take]

  ## Returns a list of issues
  #
  # GET /api/v1/issues
  #
  # parameters:
  #   page[size]: INTEGER
  #   page[number]: INTEGER
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
  #               "updated_at":"2015-09-06T15:53:51.594Z",
  #             },
  #             "relationships": {
  #               "comments": {
  #                 "data": []
  #               },
  #               "creator": {
  #                 "data": {
  #                   "id": "2",
  #                   "type": "users"
  #                 }
  #               },
  #               "assignee": {
  #                 "data": {
  #                   "id": "1",
  #                   "type": "users"
  #                 }
  #               }
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
  #               "updated_at":"2015-09-06T16:02:25.640Z",
  #             },
  #             "relationships": {
  #               "comments": {
  #                 "data": [
  #                   {
  #                     "type": "comments",
  #                     "id": "1"
  #                   }
  #                 ]
  #               },
  #               "creator": {
  #                 "data": {
  #                   "id": "1",
  #                   "type": "users"
  #                 }
  #               },
  #               "assignee": {
  #                 "data": null
  #               }
  #             }
  #           }
  #         ],
  #          "links": {
  #            "self": "http://mysterious-issue-tracker.dev/api/v1/issues?page%5Bnumber%5D=1&page%5Bsize%5D=2",
  #            "next": "http://mysterious-issue-tracker.dev/api/v1/issues?page%5Bnumber%5D=2&page%5Bsize%5D=2",
  #            "last": "http://mysterious-issue-tracker.dev/api/v1/issues?page%5Bnumber%5D=2&page%5Bsize%5D=2"
  #          },
  #          "meta": {
  #            "total": 2,
  #             "current_page": 1,
  #             "on_page": 2,
  #             "total_pages": 2
  #          }
  #       }
  def index
    @issues = policy_scope(Issue).page(params[:page][:number]).per(params[:page][:size])

    render json: @issues, meta: {
      total: Issue.count,
      current_page: @issues.current_page,
      on_page: @issues.size,
      total_pages: @issues.total_pages
    }
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
  #           },
  #           "relationships": {
  #             "comments": {
  #               "data": []
  #             },
  #            "creator": {
  #               "data": {
  #                 "id": "2",
  #                 "type": "users"
  #               }
  #             },
  #             "assignee": {
  #               "data": {
  #                 "id": "1",
  #                 "type": "users"
  #               }
  #             }
  #           }
  #         }
  #       }
  def show
    authorize @issue
    render json: @issue
  end

  ## Creates an issue
  #
  # POST /api/v1/issues
  #
  # restrictions
  #   must be authenticated
  #
  # body parameters:
  #   issue[tite]: STRING, required
  #   issue[description]: STRING, required
  #   issue[priority]: STRING, required, [minor, major, critical, blocker]
  #   issue[assignee_id]: INTEGER - user id
  #
  # = Examples
  #
  #   resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'critical'}})
  #
  #   resp.status
  #   => 201
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
  #           },
  #           "relationships": {
  #             "comments": {
  #               "data": []
  #             },
  #            "creator": {
  #               "data": {
  #                 "id": "2",
  #                 "type": "users"
  #               }
  #             },
  #             "assignee": {
  #               "data": null
  #             }
  #           }
  #         }
  #       }
  #
  #   resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments'})
  #
  #   resp.status
  #   => 422
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
    @issue = current_user.issues.build(permitted_attributes(Issue.new))
    authorize @issue
    if @issue.save
      render json: @issue, status: :created, location: api_v1_issue_url(@issue)
    else
      validation_errors(@issue.errors)
    end
  rescue ArgumentError => e
    skip_authorization
    invalid_params(e)
  end

  ## Assigns the issue to current_user
  #
  # PATCH /api/v1/issues/:id/take
  #
  # = Examples
  #
  #   resp = conn.patch("/api/v1/issues/1/take")
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
  #             "title":"No comments",
  #             "description":"Can't comment issues",
  #             "priority":"major",
  #             "status":"open",
  #             "created_at":"2015-09-06T15:53:51.594Z",
  #             "updated_at":"2015-09-06T15:53:51.594Z"
  #           },
  #           "relationships": {
  #             "comments": {
  #               "data": []
  #             },
  #            "creator": {
  #               "data": {
  #                 "id": "2",
  #                 "type": "users"
  #               }
  #             },
  #             "assignee": {
  #               "data": {
  #                 "id": "1",
  #                 "type": "users"
  #               }
  #             }
  #           }
  #         }
  #       }
  def take
    authorize @issue
    @issue.update_attributes(assignee: current_user)

    render json: @issue
  end

  ## Updates an issue
  #
  # PATCH /api/v1/issues/:id
  #
  # body parameters:
  #   issue[tite]: STRING
  #   issue[description]: STRING
  #   issue[priority]: STRING, [minor, major, critical, blocker]
  #   issue[status]: STRING, [open, in_progress, fixed, rejected]
  #   issue[assignee_id]: INTEGER - user id
  #
  # = Examples
  #
  #   resp = conn.patch("/api/v1/issues/1", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'major'}})
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
  #             "title":"No comments",
  #             "description":"Can't comment issues",
  #             "priority":"major",
  #             "status":"open",
  #             "created_at":"2015-09-06T15:53:51.594Z",
  #             "updated_at":"2015-09-06T15:53:51.594Z"
  #           },
  #           "relationships": {
  #             "comments": {
  #               "data": []
  #             },
  #            "creator": {
  #               "data": {
  #                 "id": "2",
  #                 "type": "users"
  #               }
  #             },
  #             "assignee": {
  #               "data": {
  #                 "id": "1",
  #                 "type": "users"
  #               }
  #             }
  #           }
  #         }
  #       }
  #
  #   resp = conn.patch("/api/v1/issues/1", {issue: {title: ''})
  #
  #   resp.status
  #   => 422
  #
  #   resp.body
  #   => {
  #        "errors":[
  #          {
  #            "status":"422",
  #            "title":"Invalid title",
  #            "detail":"can't be blank"
  #          }
  #        ]
  #      }
  def update
    authorize @issue
    if @issue.update_attributes(permitted_attributes(@issue))
      render json: @issue
    else
      validation_errors(@issue.errors)
    end
  rescue ArgumentError => e
    invalid_params(e)
  end

  ## Deletes an issue
  #
  # DELETE /api/v1/issues/:id
  #
  # = Examples
  #
  #   resp = conn.delete("/api/v1/issues/1")
  #
  #   resp.status
  #   => 204
  def destroy
    authorize @issue
    @issue.destroy

    head :no_content
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end
end
